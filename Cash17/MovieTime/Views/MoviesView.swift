import SwiftUI

struct MoviesView: View {
    @StateObject private var viewModel = MoviesViewModel()
    @State private var showingAddMovie = false
    @State private var showingFilters = false
    @State private var showingSortOptions = false
    @State private var showingSortModal = false
    @State private var selectedMovies: Set<Movie> = []
    @State private var isSelectionMode = false
    @State private var showingArchiveConfirmation = false
    @State private var movieToArchive: Movie?
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if viewModel.hasActiveFilters() {
                        activeFiltersView
                    }
                    
                    if viewModel.isLoading {
                        loadingView
                    } else if viewModel.filteredMovies.isEmpty {
                        emptyStateView
                    } else {
                        moviesListView
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddMovie) {
                MovieFormView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingFilters) {
                FiltersView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingSortModal) {
                SortOptionsView(viewModel: viewModel)
            }
            .actionSheet(isPresented: $showingSortOptions) {
                sortActionSheet
            }
            .alert("Delete Movie", isPresented: $showingArchiveConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let movie = movieToArchive {
                        viewModel.archiveMovie(movie)
                    }
                }
            } message: {
                Text("This movie will be permanently deleted.")
            }
        }
        .onAppear {
            viewModel.loadMovies()
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Movies")
                    .font(FontManager.largeTitle)
                    .foregroundColor(AppColors.primaryText)
                
                HStack {
                    Text("\(viewModel.filteredMovies.count) movies")
                        .font(FontManager.caption)
                        .foregroundColor(AppColors.secondaryText)
                    
                    if viewModel.sortOption != .dateDescending {
                        Text("• \(viewModel.sortOption.rawValue)")
                            .font(FontManager.caption)
                            .foregroundColor(AppColors.lightGray)
                    }
                }
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                Button(action: { showingSortModal = true }) {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                }
                
                Button(action: { showingFilters = true }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(viewModel.hasActiveFilters() ? AppColors.warning : AppColors.primaryText)
                }
                
                Button(action: { showingAddMovie = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var activeFiltersView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(viewModel.selectedGenres), id: \.self) { genre in
                    FilterChip(text: genre) {
                        viewModel.selectedGenres.remove(genre)
                        viewModel.applyFilters()
                    }
                }
                
                if !viewModel.searchText.isEmpty {
                    FilterChip(text: "Search: \(viewModel.searchText)") {
                        viewModel.searchText = ""
                        viewModel.applyFilters()
                    }
                }
                
                if viewModel.ratingRange != 1...10 {
                    FilterChip(text: "Rating: \(viewModel.ratingRange.lowerBound)-\(viewModel.ratingRange.upperBound)") {
                        viewModel.ratingRange = 1...10
                        viewModel.applyFilters()
                    }
                }
                
                if viewModel.dateFilter != .all {
                    FilterChip(text: viewModel.dateFilter.rawValue) {
                        viewModel.dateFilter = .all
                        viewModel.applyFilters()
                    }
                }
                
                Button("Clear All") {
                    viewModel.clearFilters()
                }
                .font(FontManager.caption)
                .foregroundColor(AppColors.error)
                .padding(.leading, 8)
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 8)
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: AppColors.primaryText))
                .scaleEffect(1.5)
            
            Text("Loading movies...")
                .font(FontManager.body)
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "film")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.lightGray)
            
            VStack(spacing: 8) {
                Text(viewModel.movies.isEmpty ? "You haven't added any movies yet" : "No movies found")
                    .font(FontManager.poppinsMedium(size: 15))
                    .foregroundColor(AppColors.secondaryText)
                
                Text(viewModel.movies.isEmpty ? "Start building your movie diary" : "Try adjusting your filters")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.lightGray)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                if viewModel.movies.isEmpty {
                    showingAddMovie = true
                } else {
                    viewModel.clearFilters()
                }
            }) {
                Text(viewModel.movies.isEmpty ? "Add First Movie" : "Clear Filters")
                    .font(FontManager.headline)
                    .foregroundColor(AppColors.background)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppColors.primaryText)
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
    
    private var moviesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredMovies, id: \.id) { movie in
                    MovieCardView(
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
                                isSelectionMode = true
                                selectedMovies.insert(movie)
                            }
                        },
                        onSwipeLeft: {
                            movieToArchive = movie
                            showingArchiveConfirmation = true
                        },
                        onSwipeRight: {
                            viewModel.toggleFavorite(movie)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
    }
    
    private var sortActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Options"),
            buttons: [
                .default(Text("Filter")) {
                    showingFilters = true
                },
                .default(Text("Sort")) {
                    showingSortModal = true
                },
                .default(Text("Clear Filters")) {
                    viewModel.clearFilters()
                },
                .default(Text("Reset Sort")) {
                    viewModel.sortOption = .dateDescending
                    viewModel.applyFilters()
                },
                .cancel()
            ]
        )
    }
    
    private func toggleSelection(_ movie: Movie) {
        if selectedMovies.contains(movie) {
            selectedMovies.remove(movie)
        } else {
            selectedMovies.insert(movie)
        }
        
        if selectedMovies.isEmpty {
            isSelectionMode = false
        }
    }
}

struct FilterChip: View {
    let text: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(text)
                .font(FontManager.caption)
                .foregroundColor(AppColors.primaryText)
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(AppColors.primaryText.opacity(0.2))
        )
    }
}

#Preview {
    MoviesView()
}
