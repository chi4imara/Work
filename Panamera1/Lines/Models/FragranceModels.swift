import Foundation

enum Season: String, CaseIterable, Identifiable, Codable {
    case spring = "Spring"
    case summer = "Summer"
    case autumn = "Autumn"
    case winter = "Winter"
    case allSeasons = "All Seasons"
    
    var id: String { rawValue }
    
    var displayName: String {
        return rawValue
    }
}

enum Style: String, CaseIterable, Identifiable {
    case evening = "Evening"
    case casual = "Casual"
    case bright = "Bright"
    case universal = "Universal"
    case custom = "Custom"
    
    var id: String { rawValue }
    
    var displayName: String {
        return rawValue
    }
}

struct Fragrance: Identifiable, Codable {
    let id: UUID
    var name: String
    var brand: String
    var season: Season
    var style: String
    var rating: Int
    var description: String
    var isFavorite: Bool
    var dateAdded: Date
    
    init(name: String, brand: String, season: Season, style: String, rating: Int, description: String, isFavorite: Bool = false) {
        self.id = UUID()
        self.name = name
        self.brand = brand
        self.season = season
        self.style = style
        self.rating = rating
        self.description = description
        self.isFavorite = isFavorite
        self.dateAdded = Date()
    }
}

struct Category: Identifiable {
    let id = UUID()
    let name: String
    let count: Int
    let type: CategoryType
}

enum CategoryType {
    case season(Season)
    case style(String)
}
