import Foundation
import SwiftUI
import CoreData

class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var filteredMovies: [Movie] = []
    @Published var isLoading = false
    @Published var searchText = ""
    @Published var selectedGenres: Set<String> = []
    @Published var ratingRange: ClosedRange<Int> = 1...10
    @Published var dateFilter: DateFilter = .all
    @Published var sortOption: SortOption = .dateDescending
    
    private let coreDataManager = CoreDataManager.shared
    
    enum DateFilter: String, CaseIterable {
        case all = "All Time"
        case today = "Today"
        case week = "This Week"
        case month = "This Month"
        case year = "This Year"
        case custom = "Custom Range"
    }
    
    enum SortOption: String, CaseIterable {
        case dateDescending = "Date (Newest First)"
        case dateAscending = "Date (Oldest First)"
        case titleAscending = "Title (A-Z)"
        case titleDescending = "Title (Z-A)"
        case ratingDescending = "Rating (High to Low)"
        case ratingAscending = "Rating (Low to High)"
    }
    
    let availableGenres = [
        "Action", "Adventure", "Animation", "Biography", "Comedy", "Crime",
        "Documentary", "Drama", "Family", "Fantasy", "History", "Horror",
        "Music", "Mystery", "Romance", "Sci-Fi", "Sport", "Thriller", "War", "Western"
    ]
    
    init() {
        loadMovies()
    }
    
    func loadMovies() {
        isLoading = true
        movies = coreDataManager.fetchMovies()
        applyFilters()
        isLoading = false
    }
    
    func addMovie(title: String, genre: String, watchDate: Date, rating: Int16, review: String?, watchLocation: String?, notes: [String], isFavorite: Bool) {
        let _ = coreDataManager.createMovie(
            title: title,
            genre: genre,
            watchDate: watchDate,
            rating: rating,
            review: review,
            watchLocation: watchLocation,
            notes: notes,
            isFavorite: isFavorite
        )
        loadMovies()
    }
    
    func updateMovie(_ movie: Movie, title: String, genre: String, watchDate: Date, rating: Int16, review: String?, watchLocation: String?, notes: [String], isFavorite: Bool) {
        movie.title = title
        movie.genre = genre
        movie.watchDate = watchDate
        movie.rating = rating
        movie.review = review
        movie.watchLocation = watchLocation
        movie.notes = notes
        movie.isFavorite = isFavorite
        movie.updatedAt = Date()
        coreDataManager.save()
        loadMovies()
    }
    
    func toggleFavorite(_ movie: Movie) {
        movie.isFavorite.toggle()
        movie.updatedAt = Date()
        coreDataManager.save()
        loadMovies()
    }
    
    func archiveMovie(_ movie: Movie) {
        coreDataManager.archiveMovie(movie)
        loadMovies()
    }
    
    func deleteMovie(_ movie: Movie) {
        coreDataManager.deleteMovie(movie)
        loadMovies()
    }
    
    func applyFilters() {
        var filtered = movies
        
        if !selectedGenres.isEmpty {
            filtered = filtered.filter { selectedGenres.contains($0.genre) }
        }
        
        filtered = filtered.filter { Int($0.rating) >= ratingRange.lowerBound && Int($0.rating) <= ratingRange.upperBound }
        
        filtered = applyDateFilter(to: filtered)
        
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        
        filtered = applySorting(to: filtered)
        
        filteredMovies = filtered
    }
    
    private func applyDateFilter(to movies: [Movie]) -> [Movie] {
        let calendar = Calendar.current
        let now = Date()
        
        switch dateFilter {
        case .all:
            return movies
        case .today:
            return movies.filter { calendar.isDate($0.watchDate, inSameDayAs: now) }
        case .week:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            return movies.filter { $0.watchDate >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return movies.filter { $0.watchDate >= monthAgo }
        case .year:
            let yearAgo = calendar.date(byAdding: .year, value: -1, to: now) ?? now
            return movies.filter { $0.watchDate >= yearAgo }
        case .custom:
            return movies 
        }
    }
    
    private func applySorting(to movies: [Movie]) -> [Movie] {
        switch sortOption {
        case .dateDescending:
            return movies.sorted { $0.watchDate > $1.watchDate }
        case .dateAscending:
            return movies.sorted { $0.watchDate < $1.watchDate }
        case .titleAscending:
            return movies.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        case .titleDescending:
            return movies.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedDescending }
        case .ratingDescending:
            return movies.sorted { $0.rating > $1.rating }
        case .ratingAscending:
            return movies.sorted { $0.rating < $1.rating }
        }
    }
    
    func clearFilters() {
        searchText = ""
        selectedGenres.removeAll()
        ratingRange = 1...10
        dateFilter = .all
        applyFilters()
    }
    
    func hasActiveFilters() -> Bool {
        return !searchText.isEmpty || !selectedGenres.isEmpty || ratingRange != 1...10 || dateFilter != .all
    }
}
