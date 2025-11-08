import SwiftUI

struct WishlistView: View {
    @StateObject private var viewModel = WishlistViewModel()
    @State private var showingAddWishlist = false
    @State private var selectedMovies: Set<WishlistMovie> = []
    @State private var isSelectionMode = false
    @State private var showingDeleteConfirmation = false
    @State private var expandedMovies: Set<UUID> = []
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.wishlistMovies.isEmpty {
                    emptyStateView
                } else {
                    wishlistContentView
                }
                
                Spacer()
            }
        }
        .onAppear {
            viewModel.loadWishlistMovies()
        }
        .sheet(isPresented: $showingAddWishlist) {
            WishlistFormView(viewModel: viewModel)
        }
        .alert("Delete Movies", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteSelectedMovies()
            }
        } message: {
            Text("Selected movies will be permanently deleted from your wishlist.")
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Want to Watch")
                    .font(FontManager.largeTitle)
                    .foregroundColor(AppColors.primaryText)
                
                Text("\(viewModel.wishlistMovies.count) movies in wishlist")
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
                    
                    Button("Delete (\(selectedMovies.count))") {
                        showingDeleteConfirmation = true
                    }
                    .font(FontManager.body)
                    .foregroundColor(AppColors.error)
                    .disabled(selectedMovies.isEmpty)
                }
            } else {
                Button(action: { showingAddWishlist = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "target")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.lightGray)
            
            VStack(spacing: 8) {
                Text("No Movies in Wishlist")
                    .font(FontManager.title3)
                    .foregroundColor(AppColors.secondaryText)
                
                Text("Add movies you want to watch in the future")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.lightGray)
                    .multilineTextAlignment(.center)
            }
            
            Button("Add First Movie") {
                showingAddWishlist = true
            }
            .font(FontManager.headline)
            .foregroundColor(AppColors.background)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.primaryText)
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
    
    private var wishlistContentView: some View {
        ScrollView {
            VStack(spacing: 16) {
                if !viewModel.priorityMovies.isEmpty {
                    priorityMoviesSection
                }
                
                if !viewModel.regularMovies.isEmpty {
                    regularMoviesSection
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
    }
    
    private var priorityMoviesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "star.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.warning)
                
                Text("Priority")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            LazyVStack(spacing: 12) {
                ForEach(viewModel.priorityMovies, id: \.id) { movie in
                    WishlistMovieCardView(
                        movie: movie,
                        isSelected: selectedMovies.contains(movie),
                        isSelectionMode: isSelectionMode,
                        isExpanded: expandedMovies.contains(movie.id),
                        onTap: {
                            if isSelectionMode {
                                toggleSelection(movie)
                            } else {
                                toggleExpansion(movie)
                            }
                        },
                        onLongPress: {
                            if !isSelectionMode {
                                enterSelectionMode(with: movie)
                            }
                        },
                        onSwipeLeft: {
                            viewModel.deleteWishlistMovie(movie)
                        },
                        onSwipeRight: {
                            viewModel.togglePriority(movie)
                        }
                    )
                }
            }
        }
    }
    
    private var regularMoviesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !viewModel.priorityMovies.isEmpty {
                HStack {
                    Text("Other Movies")
                        .font(FontManager.headline)
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
            }
            
            LazyVStack(spacing: 12) {
                ForEach(viewModel.regularMovies, id: \.id) { movie in
                    WishlistMovieCardView(
                        movie: movie,
                        isSelected: selectedMovies.contains(movie),
                        isSelectionMode: isSelectionMode,
                        isExpanded: expandedMovies.contains(movie.id),
                        onTap: {
                            if isSelectionMode {
                                toggleSelection(movie)
                            } else {
                                toggleExpansion(movie)
                            }
                        },
                        onLongPress: {
                            if !isSelectionMode {
                                enterSelectionMode(with: movie)
                            }
                        },
                        onSwipeLeft: {
                            viewModel.deleteWishlistMovie(movie)
                        },
                        onSwipeRight: {
                            viewModel.togglePriority(movie)
                        }
                    )
                }
            }
        }
    }
    
    private func toggleSelection(_ movie: WishlistMovie) {
        if selectedMovies.contains(movie) {
            selectedMovies.remove(movie)
        } else {
            selectedMovies.insert(movie)
        }
        
        if selectedMovies.isEmpty {
            exitSelectionMode()
        }
    }
    
    private func enterSelectionMode(with movie: WishlistMovie) {
        isSelectionMode = true
        selectedMovies.insert(movie)
    }
    
    private func exitSelectionMode() {
        isSelectionMode = false
        selectedMovies.removeAll()
    }
    
    private func toggleExpansion(_ movie: WishlistMovie) {
        if expandedMovies.contains(movie.id) {
            expandedMovies.remove(movie.id)
        } else {
            expandedMovies.insert(movie.id)
        }
    }
    
    private func deleteSelectedMovies() {
        for movie in selectedMovies {
            viewModel.deleteWishlistMovie(movie)
        }
        exitSelectionMode()
    }
}

struct WishlistMovieCardView: View {
    let movie: WishlistMovie
    let isSelected: Bool
    let isSelectionMode: Bool
    let isExpanded: Bool
    let onTap: () -> Void
    let onLongPress: () -> Void
    let onSwipeLeft: () -> Void
    let onSwipeRight: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var isShowingLeftAction = false
    @State private var isShowingRightAction = false
    
    var body: some View {
        ZStack {
            HStack {
                if isShowingRightAction {
                    HStack {
                        Image(systemName: movie.isPriority ? "star.slash" : "star")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(AppColors.warning)
                        
                        Text(movie.isPriority ? "Remove Priority" : "Make Priority")
                            .font(FontManager.caption)
                            .foregroundColor(AppColors.warning)
                        
                        Spacer()
                    }
                    .padding(.leading, 20)
                }
                
                Spacer()
                
                if isShowingLeftAction {
                    HStack {
                        Spacer()
                        
                        Text("Delete")
                            .font(FontManager.caption)
                            .foregroundColor(AppColors.error)
                        
                        Image(systemName: "trash")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(AppColors.error)
                    }
                    .padding(.trailing, 20)
                }
            }
            .frame(minHeight: 80)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground.opacity(0.5))
            )
            
            movieCard
        }
    }
    
    private var movieCard: some View {
        Button(action: onTap) {
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
                            onSwipeRight()
                        }) {
                            Image(systemName: movie.isPriority ? "star.fill" : "star")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(movie.isPriority ? AppColors.warning : AppColors.lightGray)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    if let genre = movie.genre, !genre.isEmpty {
                        Text(genre)
                            .font(FontManager.subheadline)
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    if let note = movie.note, !note.isEmpty {
                        Text(isExpanded ? note : movie.shortNote)
                            .font(FontManager.caption)
                            .foregroundColor(AppColors.lightGray)
                            .lineLimit(isExpanded ? nil : 2)
                            .animation(.easeInOut(duration: 0.2), value: isExpanded)
                        
                        if note.count > 50 {
                            Text(isExpanded ? "Show less" : "Show more")
                                .font(FontManager.caption2)
                                .foregroundColor(AppColors.primaryText)
                                .padding(.top, 4)
                        }
                    }
                }
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
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture {
            onLongPress()
        }
    }
}

#Preview {
    WishlistView()
}
