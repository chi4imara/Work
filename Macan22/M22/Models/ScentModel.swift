import Foundation

struct Scent: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var brand: String
    var description: String
    var season: Season
    var comment: String
    var dateAdded: Date
    
    init(name: String, brand: String = "", description: String = "", season: Season = .winter, comment: String = "") {
        self.id = UUID()
        self.name = name
        self.brand = brand
        self.description = description
        self.season = season
        self.comment = comment
        self.dateAdded = Date()
    }
}

enum Season: String, CaseIterable, Codable {
    case winter = "Winter"
    case spring = "Spring"
    case summer = "Summer"
    case autumn = "Autumn"
    
    var displayName: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .winter: return "snowflake"
        case .spring: return "leaf"
        case .summer: return "sun.max"
        case .autumn: return "leaf.fill"
        }
    }
}

struct ScentFilter {
    var brand: String = ""
    var seasons: Set<Season> = []
    var searchText: String = ""
    
    var isActive: Bool {
        return !brand.isEmpty || !seasons.isEmpty || !searchText.isEmpty
    }
    
    func matches(_ scent: Scent) -> Bool {
        let brandMatch = brand.isEmpty || scent.brand.localizedCaseInsensitiveContains(brand)
        let seasonMatch = seasons.isEmpty || seasons.contains(scent.season)
        let searchMatch = searchText.isEmpty || 
                         scent.name.localizedCaseInsensitiveContains(searchText) ||
                         scent.brand.localizedCaseInsensitiveContains(searchText) ||
                         scent.description.localizedCaseInsensitiveContains(searchText)
        
        return brandMatch && seasonMatch && searchMatch
    }
}

struct ScentCategory {
    let season: Season
    let count: Int
    
    var displayText: String {
        return "\(season.displayName) — \(count)"
    }
}
