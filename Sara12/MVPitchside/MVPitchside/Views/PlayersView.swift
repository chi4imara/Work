import SwiftUI

struct PlayersView: View {
    @ObservedObject var viewModel: MatchViewModel
    @State private var showingAddPlayer = false
    @State private var showingPlayerDetail = false
    @State private var selectedPlayer: Player?
    @State private var showingRenameAlert = false
    @State private var showingDeleteAlert = false
    @State private var playerToRename: Player?
    @State private var playerToDelete: Player?
    @State private var newPlayerName = ""
    @State private var renameText = ""
    @State private var deleteErrorMessage = ""
    @State private var showingDeleteError = false
    @State private var isSelectingMode = false
    @State private var selectedPlayers: Set<UUID> = []
    @State private var showDeleteTrash = false
    
    var sortedPlayers: [Player] {
        viewModel.players.sorted { $0.name.lowercased() < $1.name.lowercased() }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradient.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if isSelectingMode {
                        selectionToolbarView
                    }
                    
                    if viewModel.players.isEmpty {
                        emptyStateView
                    } else {
                        playersListView
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(item: $selectedPlayer) { player in
            PlayerDetailView(player: player)
        }
        .alert("Add Player", isPresented: $showingAddPlayer) {
            TextField("Player name", text: $newPlayerName)
            Button("Add") {
                if !newPlayerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    viewModel.addPlayer(newPlayerName.trimmingCharacters(in: .whitespacesAndNewlines))
                    newPlayerName = ""
                }
            }
            Button("Cancel", role: .cancel) {
                newPlayerName = ""
            }
        } message: {
            Text("Enter the name of the new player")
        }
        .alert("Rename Player", isPresented: $showingRenameAlert) {
            TextField("New name", text: $renameText)
            Button("Rename") {
                if let player = playerToRename,
                   !renameText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    viewModel.renamePlayer(
                        oldName: player.name,
                        newName: renameText.trimmingCharacters(in: .whitespacesAndNewlines)
                    )
                    renameText = ""
                    playerToRename = nil
                }
            }
            Button("Cancel", role: .cancel) {
                renameText = ""
                playerToRename = nil
            }
        } message: {
            Text("Enter the new name for \(playerToRename?.name ?? "")")
        }
        .alert("Delete Player", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let player = playerToDelete {
                    let success = viewModel.deletePlayer(player)
                    if !success {
                        let matchCount = viewModel.matches.filter { $0.mvp == player.name }.count
                        deleteErrorMessage = "Cannot delete: player is used in \(matchCount) match\(matchCount == 1 ? "" : "es")"
                        showingDeleteError = true
                    }
                    playerToDelete = nil
                }
            }
            Button("Cancel", role: .cancel) {
                playerToDelete = nil
            }
        } message: {
            Text("Are you sure you want to delete \(playerToDelete?.name ?? "")?")
        }
        .alert("Delete Selected Players", isPresented: $showDeleteTrash, actions: {
            Button("Delete", role: .destructive) {
                deleteSelectedPlayers()
            }
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text("Are you sure you want to delete \(selectedPlayers.count) player\(selectedPlayers.count == 1 ? "" : "s")?")
        })
        .alert("Cannot Delete", isPresented: $showingDeleteError) {
            Button("OK") { }
        } message: {
            Text(deleteErrorMessage)
        }
    }
    
    private var headerView: some View {
        HStack {
            if isSelectingMode {
                Button(action: {
                    isSelectingMode = false
                    selectedPlayers.removeAll()
                }) {
                    Text("Cancel")
                        .foregroundColor(.primaryAccent)
                }
                
                Spacer()
                Spacer()
                Spacer()
                
                Text("Select Players")
                    .font(.headline)
                    .foregroundColor(.primaryText)
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
                if !selectedPlayers.isEmpty {
                    Text("\(selectedPlayers.count)")
                        .font(.headline)
                        .foregroundColor(.primaryAccent)
                } else {
                    Text("")
                }
            } else {
                Text("Players")
                    .customTitle()
                
                Spacer()
                
                Button(action: { showingAddPlayer = true }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.primaryAccent)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var selectionToolbarView: some View {
        HStack {
            Button(action: {
                if selectedPlayers.count == sortedPlayers.count {
                    selectedPlayers.removeAll()
                } else {
                    selectedPlayers = Set(sortedPlayers.map { $0.id })
                }
            }) {
                Text(selectedPlayers.count == sortedPlayers.count ? "Deselect All" : "Select All")
                    .foregroundColor(.primaryAccent)
            }
            
            Spacer()
            
            if !selectedPlayers.isEmpty {
                Button(action: {
                    showDeleteTrash = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color.clear)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "person.2")
                .font(.custom("Poppins-Light", size: 80))
                .foregroundColor(.secondaryText)
            
            VStack(spacing: 12) {
                Text("No players added yet")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryText)
                
                Text("Add players to track their MVP awards and match history")
                    .font(.body)
                    .foregroundColor(.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: { showingAddPlayer = true }) {
                Text("Add First Player")
                    .font(.buttonText)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.primaryAccent)
                    .cornerRadius(25)
            }
            
            Spacer()
        }
    }
    
    private var playersListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(sortedPlayers) { player in
                    PlayerCardView(
                        player: player,
                        isSelected: selectedPlayers.contains(player.id),
                        isSelectingMode: isSelectingMode,
                        onTap: {
                            if isSelectingMode {
                                toggleSelection(for: player)
                            } else {
                                selectedPlayer = player
                            }
                        },
                        onLongPress: {
                            if !isSelectingMode {
                                isSelectingMode = true
                                toggleSelection(for: player)
                            }
                        },
                        onRename: {
                            playerToRename = player
                            renameText = player.name
                            showingRenameAlert = true
                        },
                        onDelete: {
                            playerToDelete = player
                            showingDeleteAlert = true
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private func toggleSelection(for player: Player) {
        if selectedPlayers.contains(player.id) {
            selectedPlayers.remove(player.id)
            if selectedPlayers.isEmpty {
            }
        } else {
            selectedPlayers.insert(player.id)
        }
    }
    
    private func deleteSelectedPlayers() {
        let playersToDelete = sortedPlayers.filter { selectedPlayers.contains($0.id) }
        
        for player in playersToDelete {
            let success = viewModel.deletePlayer(player)
            if !success {
                let matchCount = viewModel.matches.filter { $0.mvp == player.name }.count
                deleteErrorMessage = "Cannot delete \(player.name): player is used in \(matchCount) match\(matchCount == 1 ? "" : "es")"
                showingDeleteError = true
                break
            }
        }
        
        selectedPlayers.removeAll()
        isSelectingMode = false
    }
}

struct PlayerCardView: View {
    let player: Player
    let isSelected: Bool
    let isSelectingMode: Bool
    let onTap: () -> Void
    let onLongPress: () -> Void
    let onRename: () -> Void
    let onDelete: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    
    private let swipeThreshold: CGFloat = 60
    
    var body: some View {
        ZStack {
            if dragOffset.width < -10 && !isSelectingMode {
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text("Delete")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .frame(width: 80)
                    .padding(.trailing, 16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.red)
                .cornerRadius(12)
            }
            
            if dragOffset.width > 10 && !isSelectingMode {
                HStack {
                    VStack {
                        Image(systemName: "pencil")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text("Rename")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                    .frame(width: 80)
                    .padding(.leading, 16)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue)
                .cornerRadius(12)
            }
            
            HStack(spacing: 16) {
                if isSelectingMode {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelected ? .primaryAccent : .secondaryText)
                        .font(.title2)
                        .transition(.scale)
                }
                
                Circle()
                    .fill(Color.primaryAccent.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(String(player.name.prefix(1).uppercased()))
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primaryAccent)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(player.name)
                        .cardTitle()
                    
                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Image(systemName: "gamecontroller")
                                .font(.caption)
                                .foregroundColor(.secondaryText)
                            Text("\(player.matchesPlayed) matches")
                                .font(.cardSubtitle)
                                .foregroundColor(.secondaryText)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundColor(.warningColor)
                            Text("\(player.mvpCount) MVP\(player.mvpCount == 1 ? "" : "s")")
                                .font(.cardSubtitle)
                                .foregroundColor(.secondaryText)
                        }
                    }
                    
                    if let lastMatchDate = player.lastMatchDate {
                        Text("Last match: \(lastMatchDate.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                            .foregroundColor(.secondaryText)
                    } else {
                        Text("No matches played")
                            .font(.caption)
                            .foregroundColor(.secondaryText)
                    }
                }
                
                Spacer()
                
                if player.mvpCount > 0 && !isSelectingMode {
                    VStack {
                        Image(systemName: "crown.fill")
                            .font(.title3)
                            .foregroundColor(.warningColor)
                        
                        Text("\(player.mvpCount)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.warningColor)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.primaryAccent.opacity(0.1) : Color.cardBackground)
                    .shadow(color: Color.shadowColor, radius: 4, x: 0, y: 2)
            )
            .offset(x: isSelectingMode ? 0 : dragOffset.width, y: 0)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if !isSelectingMode {
                            dragOffset = CGSize(width: value.translation.width, height: 0)
                        }
                    }
                    .onEnded { value in
                        if !isSelectingMode {
                            if value.translation.width < -swipeThreshold {
                                onDelete()
                            } else if value.translation.width > swipeThreshold {
                                onRename()
                            }
                            
                            withAnimation(.spring()) {
                                dragOffset = .zero
                            }
                        }
                    }
            )
        }
        .onTapGesture {
            onTap()
        }
        .onLongPressGesture {
            onLongPress()
        }
    }
}

struct AddPlayerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var playerName = ""
    let onAdd: (String) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradient.background
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Player Name")
                            .font(.headline)
                            .foregroundColor(.primaryText)
                        
                        TextField("Enter player name", text: $playerName)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("Add Player")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.primaryAccent)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        let trimmedName = playerName.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !trimmedName.isEmpty {
                            onAdd(trimmedName)
                            dismiss()
                        }
                    }
                    .foregroundColor(.primaryAccent)
                    .fontWeight(.semibold)
                    .disabled(playerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

struct PlayerDetailView: View {
    let player: Player
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradient.background
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Circle()
                        .fill(Color.primaryAccent.opacity(0.1))
                        .frame(width: 100, height: 100)
                        .overlay(
                            Text(String(player.name.prefix(1).uppercased()))
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primaryAccent)
                        )
                    
                    Text(player.name)
                        .font(.title1)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryText)
                    
                    VStack(spacing: 16) {
                        HStack {
                            StatDetailCard(
                                title: "Matches Played",
                                value: "\(player.matchesPlayed)",
                                icon: "gamecontroller"
                            )
                            
                            StatDetailCard(
                                title: "MVP Awards",
                                value: "\(player.mvpCount)",
                                icon: "star.fill"
                            )
                        }
                        
                        if let lastMatchDate = player.lastMatchDate {
                            VStack(spacing: 8) {
                                Text("Last MVP Match")
                                    .font(.headline)
                                    .foregroundColor(.secondaryText)
                                
                                Text(lastMatchDate.formatted(date: .complete, time: .omitted))
                                    .font(.body)
                                    .foregroundColor(.primaryText)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.cardBackground)
                                    .shadow(color: Color.shadowColor, radius: 4, x: 0, y: 2)
                            )
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("Player Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.primaryAccent)
                }
            }
        }
    }
}

struct StatDetailCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.primaryAccent)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primaryText)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cardBackground)
                .shadow(color: Color.shadowColor, radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    PlayersView(viewModel: MatchViewModel())
}
