import SwiftUI

struct GameFormView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var gameName = ""
    @State private var selectedCategory = ""
    @State private var playerCount = ""
    @State private var gameDescription = ""
    @State private var showingNewCategoryAlert = false
    @State private var newCategoryName = ""
    
    let editingGame: Game?
    
    init(viewModel: GameViewModel, editingGame: Game? = nil) {
        self.viewModel = viewModel
        self.editingGame = editingGame
        
        if let game = editingGame {
            _gameName = State(initialValue: game.name)
            _selectedCategory = State(initialValue: game.category)
            _playerCount = State(initialValue: game.playerCount)
            _gameDescription = State(initialValue: game.description)
        }
    }
    
    private var isFormValid: Bool {
        !gameName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !gameDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.mainGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Game Name *")
                                .font(FontManager.ubuntu(size: 16, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                            
                            TextField("Enter game name", text: $gameName)
                                .font(FontManager.ubuntu(size: 16, weight: .regular))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(ColorManager.cardBackground)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(ColorManager.primaryBlue.opacity(0.3), lineWidth: 1)
                                        }
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(FontManager.ubuntu(size: 16, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Menu {
                                ForEach(viewModel.categories, id: \.name) { category in
                                    Button(category.name) {
                                        selectedCategory = category.name
                                    }
                                }
                                
                                Divider()
                                
                                Button("Create New Category") {
                                    showingNewCategoryAlert = true
                                }
                            } label: {
                                HStack {
                                    Text(selectedCategory.isEmpty ? "Select category" : selectedCategory)
                                        .font(FontManager.ubuntu(size: 16, weight: .regular))
                                        .foregroundColor(selectedCategory.isEmpty ? ColorManager.secondaryText : ColorManager.primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(ColorManager.secondaryText)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(ColorManager.cardBackground)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(ColorManager.primaryBlue.opacity(0.3), lineWidth: 1)
                                        }
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Number of Players")
                                .font(FontManager.ubuntu(size: 16, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                            
                            TextField("e.g., 3-8", text: $playerCount)
                                .font(FontManager.ubuntu(size: 16, weight: .regular))
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(ColorManager.cardBackground)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(ColorManager.primaryBlue.opacity(0.3), lineWidth: 1)
                                        }
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description / Rules *")
                                .font(FontManager.ubuntu(size: 16, weight: .medium))
                                .foregroundColor(ColorManager.primaryText)
                            
                            TextEditor(text: $gameDescription)
                                .font(FontManager.ubuntu(size: 16, weight: .regular))
                                .padding(8)
                                .frame(minHeight: 120)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(ColorManager.cardBackground)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(ColorManager.primaryBlue.opacity(0.3), lineWidth: 1)
                                        }
                                )
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(editingGame == nil ? "New Game" : "Edit Game")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorManager.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveGame()
                    }
                    .foregroundColor(isFormValid ? ColorManager.primaryBlue : ColorManager.secondaryText)
                    .disabled(!isFormValid)
                }
            }
        }
        .alert("New Category", isPresented: $showingNewCategoryAlert) {
            TextField("Category name", text: $newCategoryName)
            Button("Cancel", role: .cancel) {
                newCategoryName = ""
            }
            Button("Save") {
                if !newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    viewModel.addCategory(newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines))
                    selectedCategory = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
                    newCategoryName = ""
                }
            }
        } message: {
            Text("Enter a name for the new category")
        }
    }
    
    private func saveGame() {
        let trimmedName = gameName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = gameDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let editingGame = editingGame {
            var updatedGame = editingGame
            updatedGame.name = trimmedName
            updatedGame.category = selectedCategory
            updatedGame.playerCount = playerCount.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedGame.description = trimmedDescription
            
            viewModel.updateGame(updatedGame)
        } else {
            let newGame = Game(
                name: trimmedName,
                category: selectedCategory,
                playerCount: playerCount.trimmingCharacters(in: .whitespacesAndNewlines),
                description: trimmedDescription
            )
            
            viewModel.addGame(newGame)
        }
        
        dismiss()
    }
}

#Preview {
    GameFormView(viewModel: GameViewModel())
}
