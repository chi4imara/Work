import SwiftUI

struct PlayerManagementView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @Environment(\.dismiss) var dismiss
    @State private var newPlayerName = ""
    @State private var playerToRename: Player?
    @State private var renameText = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    private var sessionPlayerNames: [String] {
        dataManager.sessions.flatMap { $0.players }
    }
    
    var allPlayerNames: Set<String> {
        Set(sessionPlayerNames)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Add New Player")
                            .font(AppFonts.semiBold(size: 18))
                            .foregroundColor(AppColors.primaryText)
                        
                        HStack(spacing: 12) {
                            TextField("Player name", text: $newPlayerName)
                                .font(AppFonts.regular(size: 16))
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                            
                            Button(action: addPlayer) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(AppColors.primaryBlue)
                            }
                            .disabled(newPlayerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                    .padding()
                    .background(AppColors.cardBackground)
                    
                    Divider()
                    
                    if dataManager.players.isEmpty {
                        EmptyStateView(
                            icon: "person.2.fill",
                            title: "No Players",
                            subtitle: "Add your first player above",
                            action: nil,
                            actionTitle: nil
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(dataManager.players) { player in
                                    PlayerRowView(
                                        player: player,
                                        isUsed: allPlayerNames.contains(player.name),
                                        onRename: {
                                            playerToRename = player
                                            renameText = player.name
                                        },
                                        onDelete: {
                                            if !allPlayerNames.contains(player.name) {
                                                dataManager.deletePlayer(player)
                                            } else {
                                                errorMessage = "Cannot delete player who participated in sessions"
                                                showError = true
                                            }
                                        }
                                    )
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Manage Players")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
        .alert("Rename Player", isPresented: Binding(
            get: { playerToRename != nil },
            set: { if !$0 { playerToRename = nil } }
        )) {
            TextField("New name", text: $renameText)
            Button("Cancel", role: .cancel) {
                playerToRename = nil
            }
            Button("Rename") {
                if let player = playerToRename {
                    let trimmed = renameText.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmed.isEmpty {
                        dataManager.updatePlayer(oldName: player.name, newName: trimmed)
                    }
                }
                playerToRename = nil
            }
        } message: {
            Text("Enter new name for the player")
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func addPlayer() {
        let trimmed = newPlayerName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        if dataManager.players.contains(where: { $0.name == trimmed }) {
            errorMessage = "Player with this name already exists"
            showError = true
            return
        }
        
        let player = Player(name: trimmed)
        dataManager.addPlayer(player)
        newPlayerName = ""
    }
}

struct PlayerRowView: View {
    let player: Player
    let isUsed: Bool
    let onRename: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(player.name)
                    .font(AppFonts.medium(size: 16))
                    .foregroundColor(AppColors.primaryText)
                
                if isUsed {
                    Text("Used in sessions")
                        .font(AppFonts.regular(size: 12))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            Spacer()
            
            Button(action: onRename) {
                Image(systemName: "pencil.circle")
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.primaryBlue)
            }
            .buttonStyle(.plain)
            
            Button(action: onDelete) {
                Image(systemName: "trash.circle")
                    .font(.system(size: 24))
                    .foregroundColor(isUsed ? AppColors.secondaryText.opacity(0.5) : AppColors.error)
            }
            .buttonStyle(.plain)
            .disabled(isUsed)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

