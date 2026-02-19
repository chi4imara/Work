import Foundation

enum Season: String, CaseIterable, Identifiable, Codable {
    case spring = "Spring"
    case summer = "Summer"
    case autumn = "Autumn"
    case winter = "Winter"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .spring: return "Spring"
        case .summer: return "Summer"
        case .autumn: return "Autumn"
        case .winter: return "Winter"
        }
    }
    
    var icon: String {
        switch self {
        case .spring: return "leaf"
        case .summer: return "sun.max"
        case .autumn: return "leaf.fill"
        case .winter: return "snowflake"
        }
    }
}

struct SeasonItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var season: Season
    var comment: String
    var isFavorite: Bool
    let dateCreated: Date
    
    init(name: String, season: Season, comment: String = "", isFavorite: Bool = false) {
        self.id = UUID()
        self.name = name
        self.season = season
        self.comment = comment
        self.isFavorite = isFavorite
        self.dateCreated = Date()
    }
}
