import SwiftUI

struct FavoritesView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: GamesViewModel
    @State private var sortOption: FavoritesSortOption = .alphabetical
    @State private var showingClearAlert = false
    @State private var gameToShow: Game?
    @State private var showingToast = false
    @State private var toastMessage = ""
    
    enum FavoritesSortOption: String, CaseIterable {
        case alphabetical = "Alphabetical"
        case dateAdded = "Date Added to Favorites"
        
        var displayName: String { rawValue }
    }
    
    private var favoriteGames: [Game] {
        let favorites = viewModel.games.filter { $0.isFavorite }
        switch sortOption {
        case .alphabetical:
            return favorites.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .dateAdded:
            return favorites.sorted { $0.dateModified > $1.dateModified }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                
                if favoriteGames.isEmpty {
                    emptyStateView
                } else {
                    favoritesList
                }
                
            }
            .overlay(
                toastView,
                alignment: .top
            )
            .sheet(item: $gameToShow) { game in
                GameDetailView(game: game, gamesViewModel: viewModel)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Favorites")
                        .font(AppFonts.title1)
                        .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.accent)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Sort Alphabetically") {
                            sortOption = .alphabetical
                        }
                        
                        Button("Sort by Date Added") {
                            sortOption = .dateAdded
                        }
                        
                        Divider()
                        
                        Button("Clear All Favorites") {
                            showingClearAlert = true
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.title2)
                            .foregroundColor(AppColors.primaryText)
                    }
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Favorites")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Menu {
                Button("Sort Alphabetically") {
                    sortOption = .alphabetical
                }
                
                Button("Sort by Date Added") {
                    sortOption = .dateAdded
                }
                
                Divider()
                
                Button("Clear All Favorites") {
                    showingClearAlert = true
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.title2)
                    .foregroundColor(AppColors.primaryText)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .alert("Clear All Favorites", isPresented: $showingClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear All", role: .destructive) {
                clearAllFavorites()
            }
        } message: {
            Text("Are you sure you want to remove all games from favorites?")
        }
    }
    
    private var favoritesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(favoriteGames) { game in
                    ZStack {
                        NavigationLink(destination: GameDetailView(game: game, gamesViewModel: viewModel)) {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        FavoriteGameCard(
                            game: game,
                            onTap: {
                                gameToShow = game
                            },
                            onRemoveFromFavorites: {
                                viewModel.toggleFavorite(for: game)
                                showToast("Removed from favorites")
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .refreshable {
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "star")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 8) {
                Text("No favorites yet")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add games to favorites to see them here")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                dismiss()
            } label: {
                Text("Browse Games")
                    .font(AppFonts.buttonMedium)
                    .foregroundColor(AppColors.primaryText)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(AppColors.accent)
                    )
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var toastView: some View {
        Group {
            if showingToast {
                Text(toastMessage)
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColors.success)
                    )
                    .padding(.top, 50)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
    
    private func clearAllFavorites() {
        for game in favoriteGames {
            viewModel.toggleFavorite(for: game)
        }
        showToast("All favorites cleared")
    }
    
    private func showToast(_ message: String) {
        toastMessage = message
        withAnimation(.easeInOut(duration: 0.3)) {
            showingToast = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showingToast = false
            }
        }
    }
}

struct FavoriteGameCard: View {
    let game: Game
    let onTap: () -> Void
    let onRemoveFromFavorites: () -> Void
    
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            HStack(spacing: 16) {
                Image(systemName: game.category.iconName)
                    .font(.title2)
                    .foregroundColor(AppColors.accent)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(AppColors.buttonBackground)
                            .overlay(
                                Circle()
                                    .stroke(AppColors.buttonBorder, lineWidth: 1)
                            )
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(game.name)
                        .font(AppFonts.bodyMedium)
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(1)
                    
                    Text(game.category.displayName)
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Button(action: {
                    onRemoveFromFavorites()
                }) {
                    Image(systemName: "star.fill")
                        .foregroundColor(AppColors.accent)
                        .font(.system(size: 16))
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
            )
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    ZStack {
        BackgroundView()
        FavoritesView()
            .environmentObject(GamesViewModel())
    }
}
