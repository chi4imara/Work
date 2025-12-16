import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: GameViewModel
    
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorManager.mainGradient
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Favorite Games")
                            .font(FontManager.ubuntu(size: 28, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    if viewModel.favoriteGames.isEmpty {
                        EmptyStateView(
                            title: "No Favorite Games Yet",
                            message: "Add games to your favorites to see them here",
                            buttonTitle: "Browse Games",
                            action: { withAnimation { selectedTab = 0 } }
                        )
                        
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.favoriteGames) { game in
                                    NavigationLink(destination: GameDetailView(game: game, viewModel: viewModel, openedFromFavorites: true)) {
                                        FavoriteGameCardView(game: game) {
                                            viewModel.toggleFavorite(for: game.id)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 16)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct FavoriteGameCardView: View {
    let game: Game
    let onRemoveFavorite: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(game.name)
                    .font(FontManager.ubuntu(size: 18, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("Category: \(game.category)")
                    .font(FontManager.ubuntu(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText)
                
                if !game.playerCount.isEmpty {
                    Text("Players: \(game.playerCount)")
                        .font(FontManager.ubuntu(size: 14, weight: .medium))
                        .foregroundColor(ColorManager.secondaryText)
                }
            }
            
            Spacer()
            
            Image(systemName: "star.fill")
                .foregroundColor(ColorManager.primaryYellow)
                .font(.title2)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorManager.cardBackground)
                .shadow(color: ColorManager.shadowColor, radius: 4, x: 0, y: 2)
        )
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button("Remove") {
                onRemoveFavorite()
            }
            .tint(ColorManager.errorColor)
        }
    }
}
