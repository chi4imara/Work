import SwiftUI

struct AddEditGameView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @Environment(\.dismiss) var dismiss
    
    let game: Game?
    
    @State private var name: String = ""
    @State private var minPlayers: String = "2"
    @State private var maxPlayers: String = "4"
    @State private var minTime: String = "30"
    @State private var maxTime: String = "60"
    @State private var selectedTags: Set<String> = []
    @State private var customTag: String = ""
    @State private var notes: String = ""
    @State private var isActive: Bool = true
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    let availableTags = ["Family", "Euro", "Abstract", "Party", "Cooperative", "Duel", "Strategy", "Card Game", "Deck Building", "Worker Placement"]
    
    private var isNameValid: Bool {
        !name.isEmpty
    }
    
    private var isPlayersValid: Bool {
        guard let min = Int(minPlayers), let max = Int(maxPlayers) else { return false }
        return min >= 1 && max >= min
    }
    
    private var isTimeValid: Bool {
        guard let min = Int(minTime), let max = Int(maxTime) else { return false }
        return min >= 1 && max >= min
    }
    
    var isValid: Bool {
        isNameValid && isPlayersValid && isTimeValid
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Game Name")
                                .font(AppFonts.medium(size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter game name", text: $name)
                                .font(AppFonts.regular(size: 16))
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Number of Players")
                                .font(AppFonts.medium(size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Min")
                                        .font(AppFonts.regular(size: 14))
                                        .foregroundColor(AppColors.secondaryText)
                                    TextField("2", text: $minPlayers)
                                        .keyboardType(.numberPad)
                                        .font(AppFonts.regular(size: 16))
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(12)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Max")
                                        .font(AppFonts.regular(size: 14))
                                        .foregroundColor(AppColors.secondaryText)
                                    TextField("4", text: $maxPlayers)
                                        .keyboardType(.numberPad)
                                        .font(AppFonts.regular(size: 16))
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(12)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Play Time (minutes)")
                                .font(AppFonts.medium(size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Min")
                                        .font(AppFonts.regular(size: 14))
                                        .foregroundColor(AppColors.secondaryText)
                                    TextField("30", text: $minTime)
                                        .keyboardType(.numberPad)
                                        .font(AppFonts.regular(size: 16))
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(12)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Max")
                                        .font(AppFonts.regular(size: 14))
                                        .foregroundColor(AppColors.secondaryText)
                                    TextField("60", text: $maxTime)
                                        .keyboardType(.numberPad)
                                        .font(AppFonts.regular(size: 16))
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(12)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tags")
                                .font(AppFonts.medium(size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            FlowLayout(spacing: 10) {
                                ForEach(availableTags, id: \.self) { tag in
                                    Button(action: {
                                        if selectedTags.contains(tag) {
                                            selectedTags.remove(tag)
                                        } else {
                                            selectedTags.insert(tag)
                                        }
                                    }) {
                                        Text(tag)
                                            .font(AppFonts.regular(size: 14))
                                            .foregroundColor(selectedTags.contains(tag) ? .white : AppColors.primaryBlue)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(selectedTags.contains(tag) ? AppColors.primaryBlue : AppColors.lightBlue.opacity(0.2))
                                            .cornerRadius(16)
                                    }
                                }
                            }
                            
                            HStack {
                                TextField("Add custom tag", text: $customTag)
                                    .font(AppFonts.regular(size: 14))
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                                
                                Button(action: addCustomTag) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 28))
                                        .foregroundColor(AppColors.primaryBlue)
                                }
                                .disabled(customTag.isEmpty)
                            }
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
                        
                        HStack {
                            Text("Status")
                                .font(AppFonts.medium(size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                            
                            Toggle("", isOn: $isActive)
                                .labelsHidden()
                                .tint(AppColors.primaryBlue)
                            
                            Text(isActive ? "Active" : "Inactive")
                                .font(AppFonts.regular(size: 16))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        
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
                            
                            Button(action: saveGame) {
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
            .navigationTitle(game == nil ? "New Game" : "Edit Game")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveGame()
                    }
                    .foregroundColor(!isValid ? .gray : AppColors.primaryBlue)
                    .disabled(!isValid)
                }
            }
        }
        .onAppear {
            if let game = game {
                name = game.name
                minPlayers = "\(game.minPlayers)"
                maxPlayers = "\(game.maxPlayers)"
                minTime = "\(game.minTime)"
                maxTime = "\(game.maxTime)"
                selectedTags = Set(game.tags)
                notes = game.notes
                isActive = game.isActive
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func addCustomTag() {
        let trimmed = customTag.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            selectedTags.insert(trimmed)
            customTag = ""
        }
    }
    
    private func saveGame() {
        guard isValid else { return }
        
        if game == nil && dataManager.games.contains(where: { $0.name.lowercased() == name.lowercased() }) {
            errorMessage = "A game with this name already exists"
            showError = true
            return
        }
        
        if let existingGame = game {
            let updatedGame = Game(
                id: existingGame.id,
                name: name,
                minPlayers: Int(minPlayers)!,
                maxPlayers: Int(maxPlayers)!,
                minTime: Int(minTime)!,
                maxTime: Int(maxTime)!,
                tags: Array(selectedTags),
                notes: notes,
                isActive: isActive,
                createdAt: existingGame.createdAt
            )
            dataManager.updateGame(updatedGame)
        } else {
            let newGame = Game(
                name: name,
                minPlayers: Int(minPlayers)!,
                maxPlayers: Int(maxPlayers)!,
                minTime: Int(minTime)!,
                maxTime: Int(maxTime)!,
                tags: Array(selectedTags),
                notes: notes,
                isActive: isActive
            )
            dataManager.addGame(newGame)
        }
        
        dismiss()
    }
}

