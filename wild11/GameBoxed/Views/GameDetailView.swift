import SwiftUI

struct GameDetailView: View {
    let game: Game
    @ObservedObject var viewModel: GameViewModel
    var openedFromFavorites: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    private var currentGame: Game? {
        viewModel.games.first { $0.id == game.id }
    }
    
    private var isFavorite: Bool {
        currentGame?.isFavorite ?? game.isFavorite
    }
    
    private var playerCount: String {
        currentGame?.playerCount ?? game.playerCount
    }
    
    var body: some View {
        ZStack {
            ColorManager.mainGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(currentGame?.name ?? game.name)
                            .font(FontManager.ubuntu(size: 28, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        HStack {
                            Label(currentGame?.category ?? game.category, systemImage: "tag.fill")
                                .font(FontManager.ubuntu(size: 16, weight: .medium))
                                .foregroundColor(ColorManager.primaryBlue)
                            
                            Spacer()
                            
                            if !playerCount.isEmpty {
                                Label(playerCount, systemImage: "person.2.fill")
                                    .font(FontManager.ubuntu(size: 16, weight: .medium))
                                    .foregroundColor(ColorManager.primaryBlue)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(ColorManager.cardBackground)
                            .shadow(color: ColorManager.shadowColor, radius: 8, x: 0, y: 4)
                    )
                    
                    Button(action: {
                        viewModel.toggleFavorite(for: game.id)
                    }) {
                        HStack {
                            Image(systemName: isFavorite ? "star.fill" : "star")
                                .foregroundColor(isFavorite ? ColorManager.primaryYellow : ColorManager.primaryBlue)
                            
                            Text(isFavorite ? "Remove from Favorites" : "Add to Favorites")
                                .font(FontManager.ubuntu(size: 16, weight: .medium))
                                .foregroundColor(ColorManager.primaryBlue)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(ColorManager.cardBackground)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                    .stroke(ColorManager.primaryBlue, lineWidth: 2)
                                }
                                
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Description & Rules")
                            .font(FontManager.ubuntu(size: 20, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Text(currentGame?.description ?? game.description)
                            .font(FontManager.ubuntu(size: 16, weight: .regular))
                            .foregroundColor(ColorManager.primaryText)
                            .lineSpacing(4)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(ColorManager.cardBackground)
                            .shadow(color: ColorManager.shadowColor, radius: 8, x: 0, y: 4)
                    )
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Edit") {
                        showingEditSheet = true
                    }
                    
                    Button("Delete", role: .destructive) {
                        showingDeleteAlert = true
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(ColorManager.primaryBlue)
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            if let currentGame = currentGame {
                GameFormView(viewModel: viewModel, editingGame: currentGame)
            } else {
                GameFormView(viewModel: viewModel, editingGame: game)
            }
        }
        .alert("Delete Game", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let currentGame = currentGame {
                    viewModel.deleteGame(currentGame)
                } else {
                    viewModel.deleteGame(game)
                }
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete \"\(currentGame?.name ?? game.name)\"? This action cannot be undone.")
        }
        .onChange(of: isFavorite) { newValue in
            if !newValue && openedFromFavorites {
                dismiss()
            }
        }
    }
}
