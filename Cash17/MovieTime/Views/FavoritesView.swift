import SwiftUI

enum FavoritesSortOption: String, CaseIterable {
    case dateAdded = "Date Added to Favorites"
    case watchDate = "Watch Date"
    case title = "Title"
    case rating = "Rating"
}

struct FavoritesView: View {
    @StateObject private var moviesViewModel = MoviesViewModel()
    @State private var favoriteMovies: [Movie] = []
    @State private var selectedMovies: Set<Movie> = []
    @State private var isSelectionMode = false
    @State private var showingRemoveConfirmation = false
    @State private var showingSortModal = false
    @State private var sortOption: FavoritesSortOption = .dateAdded
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if favoriteMovies.isEmpty {
                    emptyStateView
                } else {
                    favoritesListView
                }
                
                Spacer()
            }
        }
        .onAppear {
            loadFavoriteMovies()
        }
        .alert("Remove from Favorites", isPresented: $showingRemoveConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                removeSelectedFromFavorites()
            }
        } message: {
            Text("Selected movies will be removed from your favorites list.")
        }
        .sheet(isPresented: $showingSortModal) {
            FavoritesSortView(sortOption: $sortOption, favoriteMovies: $favoriteMovies)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Favorites")
                    .font(FontManager.largeTitle)
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(favoriteMovies.count) favorite movies")
                    .font(FontManager.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            if isSelectionMode {
                HStack(spacing: 16) {
                    Button("Cancel") {
                        exitSelectionMode()
                    }
                    .font(FontManager.body)
                    .foregroundColor(AppColors.secondaryText)
                    
                    Button("Remove (\(selectedMovies.count))") {
                        showingRemoveConfirmation = true
                    }
                    .font(FontManager.body)
                    .foregroundColor(AppColors.error)
                    .disabled(selectedMovies.isEmpty)
                }
            } else {
                Button(action: { showingSortModal = true }) {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "star")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.lightGray)
            
            VStack(spacing: 8) {
                Text("No Favorite Movies Yet")
                    .font(FontManager.title3)
                    .foregroundColor(AppColors.secondaryText)
                
                Text("Movies you mark as favorites will appear here")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.lightGray)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
    
    private var favoritesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(favoriteMovies, id: \.id) { movie in
                    FavoriteMovieCardView(
                        movie: movie,
                        isSelected: selectedMovies.contains(movie),
                        isSelectionMode: isSelectionMode,
                        onTap: {
                            if isSelectionMode {
                                toggleSelection(movie)
                            } else {
                            }
                        },
                        onLongPress: {
                            if !isSelectionMode {
                                enterSelectionMode(with: movie)
                            }
                        },
                        onSwipeLeft: {
                            removeFromFavorites(movie)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
    }
    
    private func loadFavoriteMovies() {
        let movies = CoreDataManager.shared.fetchFavoriteMovies()
        favoriteMovies = applySorting(to: movies)
    }
    
    private func applySorting(to movies: [Movie]) -> [Movie] {
        switch sortOption {
        case .dateAdded:
            return movies.sorted { $0.updatedAt > $1.updatedAt }
        case .watchDate:
            return movies.sorted { $0.watchDate > $1.watchDate }
        case .title:
            return movies.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        case .rating:
            return movies.sorted { $0.rating > $1.rating }
        }
    }
    
    private func toggleSelection(_ movie: Movie) {
        if selectedMovies.contains(movie) {
            selectedMovies.remove(movie)
        } else {
            selectedMovies.insert(movie)
        }
        
        if selectedMovies.isEmpty {
            exitSelectionMode()
        }
    }
    
    private func enterSelectionMode(with movie: Movie) {
        isSelectionMode = true
        selectedMovies.insert(movie)
    }
    
    private func exitSelectionMode() {
        isSelectionMode = false
        selectedMovies.removeAll()
    }
    
    private func removeFromFavorites(_ movie: Movie) {
        moviesViewModel.toggleFavorite(movie)
        loadFavoriteMovies()
    }
    
    private func removeSelectedFromFavorites() {
        for movie in selectedMovies {
            moviesViewModel.toggleFavorite(movie)
        }
        exitSelectionMode()
        loadFavoriteMovies()
    }
}

struct FavoriteMovieCardView: View {
    let movie: Movie
    let isSelected: Bool
    let isSelectionMode: Bool
    let onTap: () -> Void
    let onLongPress: () -> Void
    let onSwipeLeft: () -> Void
    
    @StateObject private var viewModel = MoviesViewModel()
    
    @State private var dragOffset: CGSize = .zero
    @State private var isShowingLeftAction = false
    
    var body: some View {
        ZStack {
            if isShowingLeftAction {
                HStack {
                    Spacer()
                    
                    HStack {
                        Text("Remove from Favorites")
                            .font(FontManager.caption)
                            .foregroundColor(AppColors.error)
                        
                        Image(systemName: "star.slash")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(AppColors.error)
                    }
                    .padding(.trailing, 20)
                }
                .frame(height: 120)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.cardBackground.opacity(0.5))
                )
            }
            
            movieCard
        }
    }
    
    private var movieCard: some View {
        Group {
            if isSelectionMode {
                Button(action: onTap) {
                    cardContent
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                NavigationLink(destination: MovieDetailView(movie: movie, viewModel: viewModel)) {
                    cardContent
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .onLongPressGesture {
            onLongPress()
        }
    }
    
    private var cardContent: some View {
            HStack(spacing: 16) {
                if isSelectionMode {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? AppColors.success : AppColors.lightGray)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(movie.title)
                            .font(FontManager.headline)
                            .foregroundColor(AppColors.primaryText)
                            .lineLimit(2)
                        
                        Spacer()
                        
                        Button(action: {
                            onSwipeLeft()
                        }) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppColors.warning)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Text(movie.genre)
                        .font(FontManager.subheadline)
                        .foregroundColor(AppColors.secondaryText)
                    
                    HStack {
                        Text(movie.formattedWatchDate)
                            .font(FontManager.caption)
                            .foregroundColor(AppColors.lightGray)
                        
                        Spacer()
                        
                        Text(movie.ratingText)
                            .font(FontManager.caption)
                            .foregroundColor(AppColors.primaryText)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.primaryText.opacity(0.2))
                            )
                    }
                    
                    if !movie.shortReview.isEmpty && movie.shortReview != "No review" {
                        Text(movie.shortReview)
                            .font(FontManager.caption)
                            .foregroundColor(AppColors.lightGray)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? AppColors.success : Color.clear, lineWidth: 2)
            )
        }
    }

#Preview {
    FavoritesView()
}
