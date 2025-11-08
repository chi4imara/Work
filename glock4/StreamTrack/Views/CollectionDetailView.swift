import SwiftUI

struct CollectionSheetItem: Identifiable {
    let id = UUID()
    let type: SheetType
    
    enum SheetType {
        case addMovies
    }
}

struct CollectionDetailView: View {
    @ObservedObject var collectionsViewModel: CollectionsViewModel
    @ObservedObject var movieListViewModel: MovieListViewModel
    @Environment(\.dismiss) private var dismiss
    
    let collectionId: UUID
    
    @State private var showingAddMovies: CollectionSheetItem?
    @State private var selectedMovies: Set<UUID> = []
    
    private var collection: MovieCollection? {
        collectionsViewModel.collections.first { $0.id == collectionId }
    }
    
    private var moviesInCollection: [Movie] {
        guard let collection = collection else { return [] }
        return collectionsViewModel.getMoviesForCollection(collection, allMovies: movieListViewModel.movies)
    }
    
    private var availableMovies: [Movie] {
        guard let collection = collection else { return [] }
        return movieListViewModel.movies.filter { !collection.movieIds.contains($0.id) }
    }
    
    var body: some View {
        Group {
            if let collection = collection {
                NavigationView {
                    ZStack {
                        AppColors.backgroundGradient
                            .ignoresSafeArea()
                        
                        VStack(spacing: 0) {
                            headerView(collection: collection)
                        
                            if moviesInCollection.isEmpty {
                                emptyStateView(collection: collection)
                            } else {
                                moviesListView
                            }
                        }
                    }
                    .navigationTitle(collection.name)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Done") {
                                dismiss()
                            }
                            .foregroundColor(AppColors.primaryBlue)
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Add Movies") {
                                showingAddMovies = CollectionSheetItem(type: .addMovies)
                            }
                            .foregroundColor(AppColors.primaryBlue)
                            .disabled(availableMovies.isEmpty)
                        }
                    }
                }
                .sheet(item: $showingAddMovies) { item in
                    switch item.type {
                    case .addMovies:
                        AddMoviesToCollectionView(
                            collection: collection,
                            availableMovies: availableMovies,
                            collectionsViewModel: collectionsViewModel
                        )
                    }
                 }
             } else {
                 VStack {
                     Text("Collection not found")
                         .font(AppFonts.title2)
                         .foregroundColor(AppColors.primaryText)
                     
                     Button("Done") {
                         dismiss()
                     }
                     .foregroundColor(AppColors.primaryBlue)
                 }
             }
         }
     }
     
     private func headerView(collection: MovieCollection) -> some View {
         VStack(spacing: 16) {
             HStack {
                 Circle()
                     .fill(collection.color.colorValue)
                     .frame(width: 16, height: 16)
                 
                 Text(collection.description)
                     .font(AppFonts.body)
                     .foregroundColor(AppColors.secondaryText)
                 
                 Spacer()
             }
             
             HStack(spacing: 20) {
                 StatItem(
                     title: "Movies",
                     value: "\(moviesInCollection.count)",
                     color: collection.color.colorValue
                 )
                 
                 StatItem(
                     title: "Watched",
                     value: "\(moviesInCollection.filter { $0.isWatched }.count)",
                     color: AppColors.accent
                 )
                 
                 StatItem(
                     title: "Remaining",
                     value: "\(moviesInCollection.filter { !$0.isWatched }.count)",
                     color: AppColors.warning
                 )
             }
         }
         .padding(.horizontal, 20)
         .padding(.vertical, 16)
         .background(
             RoundedRectangle(cornerRadius: 16)
                 .fill(Color.white)
                 .shadow(color: AppColors.cardShadow, radius: 8, x: 0, y: 4)
         )
         .padding(.horizontal, 20)
         .padding(.top, 10)
     }
            
     private func emptyStateView(collection: MovieCollection) -> some View {
         VStack(spacing: 20) {
             Spacer()
             
             Image(systemName: "folder")
                 .font(.system(size: 60, weight: .light))
                 .foregroundColor(collection.color.colorValue.opacity(0.6))
             
             Text("Collection is Empty")
                 .font(AppFonts.title2)
                 .foregroundColor(AppColors.primaryText)
             
             Text("Add movies to this collection to get started")
                 .font(AppFonts.body)
                 .foregroundColor(AppColors.secondaryText)
                 .multilineTextAlignment(.center)
             
             if !availableMovies.isEmpty {
                 Button(action: { showingAddMovies = CollectionSheetItem(type: .addMovies) }) {
                     HStack {
                         Image(systemName: "plus")
                         Text("Add Movies")
                     }
                     .font(AppFonts.bodyMedium)
                     .foregroundColor(.white)
                     .padding(.horizontal, 24)
                     .padding(.vertical, 12)
                     .background(
                         RoundedRectangle(cornerRadius: 20)
                             .fill(collection.color.colorValue)
                     )
                 }
             } else {
                 Text("No movies available to add")
                     .font(AppFonts.body)
                     .foregroundColor(AppColors.secondaryText)
                     .italic()
             }
             
             Spacer()
         }
         .padding(.horizontal, 40)
     }
            
     private var moviesListView: some View {
         ScrollView {
             LazyVStack(spacing: 12) {
                 ForEach(moviesInCollection) { movie in
                     CollectionMovieRow(
                         movie: movie,
                         collectionColor: collection?.color.colorValue ?? AppColors.primaryBlue,
                         onRemove: {
                             if let collection = collection {
                                 collectionsViewModel.removeMovieFromCollection(movie.id, collectionId: collection.id)
                             }
                         }
                     )
                 }
             }
             .padding(.horizontal, 20)
             .padding(.top, 20)
             .padding(.bottom, 100)
         }
     }
}

struct StatItem: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(AppFonts.title3)
                .foregroundColor(color)
                .fontWeight(.bold)
            
            Text(title)
                .font(AppFonts.caption)
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity)
    }
}

struct CollectionMovieRow: View {
    let movie: Movie
    let collectionColor: Color
    let onRemove: () -> Void
    
    @State private var showingRemoveAlert = false
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(AppFonts.bodyMedium)
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(1)
                
                Text(movie.displaySubtitle)
                    .font(AppFonts.caption)
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Circle()
                .fill(movie.isWatched ? AppColors.accent : AppColors.warning)
                .frame(width: 8, height: 8)
            
            Button(action: { showingRemoveAlert = true }) {
                Image(systemName: "minus.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.error)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: AppColors.cardShadow, radius: 4, x: 0, y: 2)
        )
        .alert("Remove Movie", isPresented: $showingRemoveAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                onRemove()
            }
        } message: {
            Text("Remove '\(movie.title)' from this collection?")
        }
    }
}

struct AddMoviesToCollectionView: View {
    let collection: MovieCollection
    let availableMovies: [Movie]
    @ObservedObject var collectionsViewModel: CollectionsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedMovies: Set<UUID> = []
    @State private var searchText = ""
    
    private var filteredMovies: [Movie] {
        if searchText.isEmpty {
            return availableMovies
        } else {
            return availableMovies.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(AppColors.secondaryText)
                        
                        TextField("Search movies", text: $searchText)
                            .font(AppFonts.body)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(color: AppColors.cardShadow, radius: 5, x: 0, y: 2)
                    )
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    if filteredMovies.isEmpty {
                        VStack(spacing: 16) {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 50, weight: .light))
                                .foregroundColor(AppColors.primaryBlue.opacity(0.6))
                            
                            Text(searchText.isEmpty ? "No movies available" : "No movies found")
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.secondaryText)
                            Spacer()
                        }
                        .padding(.horizontal, 40)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 8) {
                                ForEach(filteredMovies) { movie in
                                    AddMovieRow(
                                        movie: movie,
                                        isSelected: selectedMovies.contains(movie.id)
                                    ) {
                                        if selectedMovies.contains(movie.id) {
                                            selectedMovies.remove(movie.id)
                                        } else {
                                            selectedMovies.insert(movie.id)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                }
            }
            .navigationTitle("Add Movies")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add (\(selectedMovies.count))") {
                        addSelectedMovies()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func addSelectedMovies() {
        for movieId in selectedMovies {
            collectionsViewModel.addMovieToCollection(movieId, collectionId: collection.id)
        }
        dismiss()
    }
}

struct AddMovieRow: View {
    let movie: Movie
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.secondaryText)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title)
                        .font(AppFonts.bodyMedium)
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(1)
                    
                    Text(movie.displaySubtitle)
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(1)
                }
                
                Spacer()
                
                Image(systemName: movie.type == .movie ? "film" : "tv")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.primaryBlue)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.primaryBlue.opacity(0.1) : Color.white)
                    .shadow(color: AppColors.cardShadow, radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let collection = MovieCollection(
        name: "My Favorites",
        description: "Movies I love",
        color: .blue
    )
    let collectionsViewModel = CollectionsViewModel()
    collectionsViewModel.collections = [collection]
    
    return CollectionDetailView(
        collectionsViewModel: collectionsViewModel,
        movieListViewModel: MovieListViewModel(),
        collectionId: collection.id
    )
}
