import SwiftUI

struct AddEditSessionView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @Environment(\.dismiss) var dismiss
    
    let session: GameSession?
    let preselectedGame: Game?
    
    @State private var selectedGameId: UUID?
    @State private var date: Date = Date()
    @State private var selectedPlayers: Set<String> = []
    @State private var winner: String = ""
    @State private var duration: String = ""
    @State private var location: String = ""
    @State private var notes: String = ""
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    private var isGameSelected: Bool {
        selectedGameId != nil
    }
    
    private var hasEnoughPlayers: Bool {
        selectedPlayers.count >= 2
    }
    
    private var isWinnerValid: Bool {
        !winner.isEmpty && (selectedPlayers.contains(winner) || winner == "Draw")
    }
    
    var isValid: Bool {
        isGameSelected && hasEnoughPlayers && isWinnerValid
    }
    
    private var sessionPlayerNames: [String] {
        dataManager.sessions.flatMap { $0.players }
    }
    
    private var registeredPlayerNames: [String] {
        dataManager.players.map { $0.name }
    }
    
    var allPlayerNames: [String] {
        let allNames = sessionPlayerNames + registeredPlayerNames
        return Array(Set(allNames)).sorted()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Game")
                                .font(AppFonts.medium(size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            Menu {
                                ForEach(dataManager.games) { game in
                                    Button(game.name) {
                                        selectedGameId = game.id
                                    }
                                }
                            } label: {
                                HStack {
                                    if let gameId = selectedGameId,
                                       let game = dataManager.games.first(where: { $0.id == gameId }) {
                                        Text(game.name)
                                            .font(AppFonts.regular(size: 16))
                                            .foregroundColor(AppColors.primaryText)
                                    } else {
                                        Text("Select a game")
                                            .font(AppFonts.regular(size: 16))
                                            .foregroundColor(AppColors.secondaryText)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(AppColors.primaryBlue)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Date")
                                .font(AppFonts.medium(size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            DatePicker("", selection: $date, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Players (minimum 2)")
                                .font(AppFonts.medium(size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            if !allPlayerNames.isEmpty {
                                FlowLayout(spacing: 10) {
                                    ForEach(allPlayerNames, id: \.self) { player in
                                        Button(action: {
                                            if selectedPlayers.contains(player) {
                                                selectedPlayers.remove(player)
                                                if winner == player {
                                                    winner = ""
                                                }
                                            } else {
                                                selectedPlayers.insert(player)
                                            }
                                        }) {
                                            Text(player)
                                                .font(AppFonts.regular(size: 14))
                                                .foregroundColor(selectedPlayers.contains(player) ? .white : AppColors.primaryBlue)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(selectedPlayers.contains(player) ? AppColors.primaryBlue : AppColors.lightBlue.opacity(0.2))
                                                .cornerRadius(16)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                            } else {
                                Text("No players available. Add players in the Journal tab.")
                                    .font(AppFonts.regular(size: 14))
                                    .foregroundColor(AppColors.secondaryText)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Winner")
                                .font(AppFonts.medium(size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            Menu {
                                Button("Draw") {
                                    winner = "Draw"
                                }
                                ForEach(Array(selectedPlayers).sorted(), id: \.self) { player in
                                    Button(player) {
                                        winner = player
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(winner.isEmpty ? "Select winner" : winner)
                                        .font(AppFonts.regular(size: 16))
                                        .foregroundColor(winner.isEmpty ? AppColors.secondaryText : AppColors.primaryText)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(AppColors.primaryBlue)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                            .disabled(selectedPlayers.isEmpty)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Duration (minutes, optional)")
                                .font(AppFonts.medium(size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter duration", text: $duration)
                                .keyboardType(.numberPad)
                                .font(AppFonts.regular(size: 16))
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Location (optional)")
                                .font(AppFonts.medium(size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter location", text: $location)
                                .font(AppFonts.regular(size: 16))
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes (optional)")
                                .font(AppFonts.medium(size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextEditor(text: $notes)
                                .font(AppFonts.regular(size: 16))
                                .frame(height: 100)
                                .padding(8)
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        
                        HStack(spacing: 16) {
                            Button(action: { dismiss() }) {
                                Text("Cancel")
                                    .font(AppFonts.medium(size: 16))
                                    .foregroundColor(AppColors.primaryBlue)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.primaryBlue, lineWidth: 1)
                                    )
                            }
                            
                            Button(action: saveSession) {
                                Text("Save")
                                    .font(AppFonts.medium(size: 16))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(
                                        isValid ?
                                        LinearGradient(
                                            colors: [AppColors.primaryBlue, AppColors.secondaryBlue],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ) :
                                        LinearGradient(
                                            colors: [AppColors.secondaryText.opacity(0.5), AppColors.secondaryText.opacity(0.5)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(12)
                            }
                            .disabled(!isValid)
                        }
                        .padding(.top, 8)
                    }
                    .padding()
                }
            }
            .navigationTitle(session == nil ? "New Session" : "Edit Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveSession()
                    }
                    .foregroundColor(isValid ? AppColors.primaryBlue : .gray)
                    .disabled(!isValid)
                }
            }
        }
        .onAppear {
            if let preselectedGame = preselectedGame {
                selectedGameId = preselectedGame.id
            }
            
            if let session = session {
                selectedGameId = session.gameId
                date = session.date
                selectedPlayers = Set(session.players)
                winner = session.winner
                duration = session.duration != nil ? "\(session.duration!)" : ""
                location = session.location
                notes = session.notes
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func saveSession() {
        guard isValid, let gameId = selectedGameId else { return }
        
        let durationValue = Int(duration)
        
        if let existingSession = session {
            let updatedSession = GameSession(
                id: existingSession.id,
                gameId: gameId,
                date: date,
                players: Array(selectedPlayers),
                winner: winner,
                duration: durationValue,
                location: location,
                notes: notes,
                createdAt: existingSession.createdAt
            )
            dataManager.updateSession(updatedSession)
        } else {
            let newSession = GameSession(
                gameId: gameId,
                date: date,
                players: Array(selectedPlayers),
                winner: winner,
                duration: durationValue,
                location: location,
                notes: notes
            )
            dataManager.addSession(newSession)
        }
        
        dismiss()
    }
}

