import Foundation
import Combine

class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var filteredMovies: [Movie] = []
    @Published var searchText: String = ""
    @Published var filterOptions = FilterOptions()
    @Published var sortOption: SortOption = .dateNewest
    @Published var genres: [Genre] = Genre.defaultGenres
    @Published var showingError = false
    @Published var errorMessage = ""
    
    private let userDefaults = UserDefaults.standard
    private let moviesKey = "SavedMovies"
    private let genresKey = "SavedGenres"
    private let filterKey = "SavedFilters"
    private let sortKey = "SavedSort"
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadData()
        setupBindings()
    }
    
    private func setupBindings() {
        Publishers.CombineLatest3($movies, $searchText, $filterOptions)
            .combineLatest($sortOption)
            .map { (moviesSearchFilter, sort) in
                let (movies, searchText, filterOptions) = moviesSearchFilter
                return self.applyFiltersAndSort(movies: movies, searchText: searchText, filterOptions: filterOptions, sortOption: sort)
            }
            .assign(to: \.filteredMovies, on: self)
            .store(in: &cancellables)
    }
    
    private func applyFiltersAndSort(movies: [Movie], searchText: String, filterOptions: FilterOptions, sortOption: SortOption) -> [Movie] {
        var result = movies
        
        if !searchText.isEmpty {
            result = result.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
        
        if !filterOptions.showWatched {
            result = result.filter { !$0.isWatched }
        }
        if !filterOptions.showUnwatched {
            result = result.filter { $0.isWatched }
        }
        
        if !filterOptions.showMovies {
            result = result.filter { $0.type != .movie }
        }
        if !filterOptions.showSeries {
            result = result.filter { $0.type != .series }
        }
        
        if !filterOptions.selectedGenres.isEmpty {
            result = result.filter { movie in
                guard let genre = movie.genre else { return false }
                return filterOptions.selectedGenres.contains(genre)
            }
        }
        
        switch sortOption {
        case .titleAsc:
            result.sort { $0.title.localizedCompare($1.title) == .orderedAscending }
        case .titleDesc:
            result.sort { $0.title.localizedCompare($1.title) == .orderedDescending }
        case .dateNewest:
            result.sort { $0.createdAt > $1.createdAt }
        case .dateOldest:
            result.sort { $0.createdAt < $1.createdAt }
        case .watchedLast:
            result.sort { !$0.isWatched && $1.isWatched }
        case .watchedFirst:
            result.sort { $0.isWatched && !$1.isWatched }
        }
        
        return result
    }
    
    func loadData() {
        if let data = userDefaults.data(forKey: moviesKey),
           let decodedMovies = try? JSONDecoder().decode([Movie].self, from: data) {
            movies = decodedMovies
        }
        
        if let data = userDefaults.data(forKey: genresKey),
           let decodedGenres = try? JSONDecoder().decode([Genre].self, from: data) {
            genres = decodedGenres
        }
        
        if let data = userDefaults.data(forKey: filterKey),
           let decodedFilter = try? JSONDecoder().decode(FilterOptions.self, from: data) {
            filterOptions = decodedFilter
        }
        
        if let sortString = userDefaults.string(forKey: sortKey),
           let sort = SortOption(rawValue: sortString) {
            sortOption = sort
        }
    }
    
    func saveData() {
        if let encoded = try? JSONEncoder().encode(movies) {
            userDefaults.set(encoded, forKey: moviesKey)
        }
        
        if let encoded = try? JSONEncoder().encode(genres) {
            userDefaults.set(encoded, forKey: genresKey)
        }
        
        if let encoded = try? JSONEncoder().encode(filterOptions) {
            userDefaults.set(encoded, forKey: filterKey)
        }
        
        userDefaults.set(sortOption.rawValue, forKey: sortKey)
    }
    
    func addMovie(_ movie: Movie) {
        let duplicate = movies.first { existing in
            existing.title.lowercased() == movie.title.lowercased() &&
            existing.year == movie.year &&
            existing.type == movie.type
        }
        
        if duplicate != nil {
        }
        
        movies.append(movie)
        saveData()
    }
    
    func updateMovie(_ movie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index] = movie
            saveData()
        }
    }
    
    func deleteMovie(_ movie: Movie) {
        movies.removeAll { $0.id == movie.id }
        saveData()
    }
    
    func toggleWatchedStatus(for movie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index].isWatched.toggle()
            saveData()
        }
    }
    
    func clearAllMovies() {
        movies.removeAll()
        saveData()
    }
    
    func resetFiltersAndSearch() {
        searchText = ""
        filterOptions.reset()
        saveData()
    }
    
    func addGenre(_ name: String) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty,
              trimmedName.count <= 40,
              !genres.contains(where: { $0.name.lowercased() == trimmedName.lowercased() }) else {
            return false
        }
        
        genres.append(Genre(name: trimmedName))
        saveData()
        return true
    }
    
    func deleteGenre(_ genre: Genre) {
        for index in movies.indices {
            if movies[index].genre == genre.name {
                movies[index].genre = nil
            }
        }
        
        genres.removeAll { $0.id == genre.id }
        saveData()
    }
    
    func updateGenre(_ genre: Genre, newName: String) -> Bool {
        let trimmedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty,
              trimmedName.count <= 40,
              !genres.contains(where: { $0.id != genre.id && $0.name.lowercased() == trimmedName.lowercased() }) else {
            return false
        }
        
        if let index = genres.firstIndex(where: { $0.id == genre.id }) {
            let oldName = genres[index].name
            genres[index].name = trimmedName
            
            for movieIndex in movies.indices {
                if movies[movieIndex].genre == oldName {
                    movies[movieIndex].genre = trimmedName
                }
            }
            
            saveData()
            return true
        }
        
        return false
    }
    
    func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }
}

