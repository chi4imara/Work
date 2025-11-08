import SwiftUI

struct AddEditGameView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: GamesViewModel
    
    let game: Game?
    
    @State private var name: String = ""
    @State private var selectedCategory: GameCategory = .other
    @State private var description: String = ""
    @State private var showingDeleteAlert = false
    @State private var showingDiscardAlert = false
    @State private var showingExistingGameAlert = false
    @State private var existingGame: Game?
    
    private var isEditing: Bool { game != nil }
    private var hasChanges: Bool {
        if let game = game {
            return name != game.name || 
                   selectedCategory != game.category || 
                   description != game.description
        } else {
            return !name.isEmpty || description.isEmpty == false
        }
    }
    
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        description.count <= 300
    }
    
    init(game: Game? = nil, viewModel: GamesViewModel) {
        self.game = game
        self.viewModel = viewModel
        
        if let game = game {
            _name = State(initialValue: game.name)
            _selectedCategory = State(initialValue: game.category)
            _description = State(initialValue: game.description)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Game Name *")
                                    .font(AppFonts.bodyMedium)
                                    .foregroundColor(AppColors.primaryText)
                                
                                TextField("e.g., Monopoly", text: $name)
                                    .font(AppFonts.body)
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(AppColors.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(AppColors.cardBorder, lineWidth: 1)
                                            )
                                    )
                                
                                Divider()
                                    .overlay(Color.white)
                                    .padding(.top, 10)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Category")
                                    .font(AppFonts.bodyMedium)
                                    .foregroundColor(AppColors.primaryText)
                                
                                Menu {
                                    ForEach(GameCategory.allCases) { category in
                                        Button(action: {
                                            selectedCategory = category
                                        }) {
                                            HStack {
                                                Image(systemName: category.iconName)
                                                Text(category.displayName)
                                                if selectedCategory == category {
                                                    Spacer()
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: selectedCategory.iconName)
                                            .foregroundColor(AppColors.accent)
                                        Text(selectedCategory.displayName)
                                            .foregroundColor(AppColors.primaryText)
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .foregroundColor(AppColors.secondaryText)
                                    }
                                    .font(AppFonts.body)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(AppColors.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(AppColors.cardBorder, lineWidth: 1)
                                            )
                                    )
                                }
                            }
                            
                            Divider()
                                .overlay(Color.white)
                                .padding(.top, 10)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Description")
                                        .font(AppFonts.bodyMedium)
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Spacer()
                                    
                                    Text("\(description.count)/300")
                                        .font(AppFonts.caption1)
                                        .foregroundColor(description.count > 300 ? AppColors.error : AppColors.secondaryText)
                                }
                                
                                TextField("e.g., Classic property trading game", text: $description, axis: .vertical)
                                    .font(AppFonts.body)
                                    .foregroundColor(AppColors.primaryText)
                                    .lineLimit(4...8)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(AppColors.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(AppColors.cardBorder, lineWidth: 1)
                                            )
                                    )
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isEditing ? "Edit Game" : "New Game")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        if hasChanges {
                            showingDiscardAlert = true
                        } else {
                            dismiss()
                        }
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveGame()
                    }
                    .foregroundColor(canSave ? AppColors.accent : AppColors.secondaryText)
                    .disabled(!canSave)
                }
            }
            .alert("Delete Game", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let game = game {
                        viewModel.deleteGame(game)
                    }
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to delete this game? This action cannot be undone.")
            }
            .alert("Discard Changes", isPresented: $showingDiscardAlert) {
                Button("Save", role: .cancel) {
                    saveGame()
                }
                Button("Don't Save") {
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("You have unsaved changes. What would you like to do?")
            }
            .alert("Game Already Exists", isPresented: $showingExistingGameAlert) {
                Button("Cancel", role: .cancel) { }
                if let existingGame = existingGame {
                    Button("Open Existing") {
                        dismiss()
                    }
                }
            } message: {
                Text("A game with this name already exists. Would you like to open the existing game instead?")
            }
        }
    }
    
    private func saveGame() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !isEditing && viewModel.gameExists(withName: trimmedName) {
            existingGame = viewModel.games.first { $0.name.lowercased() == trimmedName.lowercased() }
            showingExistingGameAlert = true
            return
        }
        
        if let game = game {
            var updatedGame = game
            updatedGame.updateInfo(name: trimmedName, category: selectedCategory, description: description)
            viewModel.updateGame(updatedGame)
        } else {
            let newGame = Game(name: trimmedName, category: selectedCategory, description: description)
            viewModel.addGame(newGame)
        }
        
        dismiss()
    }
}

#Preview {
    AddEditGameView(viewModel: GamesViewModel())
}
