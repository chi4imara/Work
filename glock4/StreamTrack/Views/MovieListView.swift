import SwiftUI

struct MovieSheetItem: Identifiable {
    let id = UUID()
    let type: SheetType
    
    enum SheetType {
        case addMovie
        case filters
        case sortOptions
    }
}

struct MovieListView: View {
    @EnvironmentObject var viewModel: MovieListViewModel
    @State private var showingSheet: MovieSheetItem?
    @State private var editingMovie: Movie?
    @State private var movieToDelete: Movie?
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                searchBarView
                
                if viewModel.filteredMovies.isEmpty {
                    emptyStateView
                } else {
                    movieListView
                }
            }
        }
        .sheet(item: $showingSheet) { item in
            switch item.type {
            case .addMovie:
                AddEditMovieView(viewModel: viewModel)
            case .filters:
                FilterView(viewModel: viewModel)
            case .sortOptions:
                SortView(viewModel: viewModel)
            }
        }
        .sheet(item: $editingMovie) { movie in
            AddEditMovieView(viewModel: viewModel, movieToEdit: movie)
        }
        .alert("Delete Movie", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let movie = movieToDelete {
                    viewModel.deleteMovie(movie)
                }
            }
        } message: {
            Text("Are you sure you want to delete this movie? This action cannot be undone.")
        }
        .alert("Error", isPresented: $viewModel.showingError) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("What to Watch")
                .font(AppFonts.title1)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            HStack(spacing: 15) {
                Button(action: { showingSheet = MovieSheetItem(type: .addMovie) }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(AppColors.blueGradient)
                        )
                        .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 5, x: 0, y: 2)
                }
                
                Menu {
                    Button(action: { showingSheet = MovieSheetItem(type: .filters) }) {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    }
                    
                    Button(action: { showingSheet = MovieSheetItem(type: .sortOptions) }) {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.primaryBlue)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .shadow(color: AppColors.cardShadow, radius: 5, x: 0, y: 2)
                        )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.secondaryText)
            
            TextField("Search by title", text: $viewModel.searchText)
                .font(AppFonts.body)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !viewModel.searchText.isEmpty {
                Button(action: { viewModel.searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: AppColors.cardShadow, radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal, 20)
        .padding(.top, 15)
        .padding(.bottom, 10)
    }
    
    private var movieListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredMovies) { movie in
                    MovieCardView(
                        movie: movie,
                        onToggleWatched: {
                            viewModel.toggleWatchedStatus(for: movie)
                        },
                        onEdit: {
                            editingMovie = movie
                        },
                        onDelete: {
                            movieToDelete = movie
                            showingDeleteAlert = true
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            if viewModel.movies.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "film")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(AppColors.primaryBlue.opacity(0.6))
                    
                    Text("List is empty")
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Add your first movie or series")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                    
                    Button(action: { showingSheet = MovieSheetItem(type: .addMovie) }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add")
                        }
                        .font(AppFonts.bodyMedium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppColors.blueGradient)
                        )
                    }
                }
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(AppColors.primaryBlue.opacity(0.6))
                    
                    Text("No results found")
                        .font(AppFonts.title2)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("No movies match your search criteria")
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                    
                    Button(action: { viewModel.resetFiltersAndSearch() }) {
                        Text("Reset Filters")
                            .font(AppFonts.bodyMedium)
                            .foregroundColor(AppColors.primaryBlue)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(AppColors.primaryBlue, lineWidth: 2)
                            )
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    MovieListView()
        .environmentObject(MovieListViewModel())
}
