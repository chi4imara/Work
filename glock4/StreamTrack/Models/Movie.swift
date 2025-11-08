import Foundation

struct Movie: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var year: Int?
    var type: MovieType
    var genre: String?
    var notes: String?
    var isWatched: Bool
    var createdAt: Date
    
    enum MovieType: String, CaseIterable, Codable {
        case movie = "Movie"
        case series = "Series"
        
        var displayName: String {
            switch self {
            case .movie:
                return "Movie"
            case .series:
                return "Series"
            }
        }
    }
    
    init(title: String, year: Int? = nil, type: MovieType, genre: String? = nil, notes: String? = nil, isWatched: Bool = false) {
        self.id = UUID()
        self.title = title
        self.year = year
        self.type = type
        self.genre = genre
        self.notes = notes
        self.isWatched = isWatched
        self.createdAt = Date()
    }
    
    var displaySubtitle: String {
        var components: [String] = []
        components.append(type.displayName)
        if let year = year {
            components.append(String(year))
        }
        if let genre = genre, !genre.isEmpty {
            components.append(genre)
        }
        return components.joined(separator: ", ")
    }
    
    var formattedCreatedAt: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: createdAt)
    }
}

struct Genre: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
    
    static let defaultGenres = [
        Genre(name: "Action"),
        Genre(name: "Comedy"),
        Genre(name: "Drama"),
        Genre(name: "Horror"),
        Genre(name: "Romance"),
        Genre(name: "Sci-Fi"),
        Genre(name: "Thriller"),
        Genre(name: "Animation"),
        Genre(name: "Documentary"),
        Genre(name: "Fantasy")
    ]
}

enum SortOption: String, CaseIterable {
    case titleAsc = "Title A-Z"
    case titleDesc = "Title Z-A"
    case dateNewest = "Newest First"
    case dateOldest = "Oldest First"
    case watchedLast = "Watched Last"
    case watchedFirst = "Watched First"
}

struct FilterOptions: Codable {
    var showWatched: Bool = true
    var showUnwatched: Bool = true
    var showMovies: Bool = true
    var showSeries: Bool = true
    var selectedGenres: Set<String> = []
    
    var isDefault: Bool {
        return showWatched && showUnwatched && showMovies && showSeries && selectedGenres.isEmpty
    }
    
    mutating func reset() {
        showWatched = true
        showUnwatched = true
        showMovies = true
        showSeries = true
        selectedGenres.removeAll()
    }
}
