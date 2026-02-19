import Foundation

enum StyleCategory: String, CaseIterable, Codable {
    case haircut = "Haircut"
    case beard = "Beard"
    
    var displayName: String {
        return self.rawValue
    }
}

enum StyleLength: String, CaseIterable, Codable {
    case short = "Short"
    case medium = "Medium"
    case long = "Long"
    case custom = "Custom"
    
    var displayName: String {
        return self.rawValue
    }
}

struct Style: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var category: StyleCategory
    var length: String
    var shape: String
    var description: String
    var isFavorite: Bool
    let createdAt: Date
    
    init(name: String, category: StyleCategory, length: String, shape: String, description: String, isFavorite: Bool = false) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.length = length
        self.shape = shape
        self.description = description
        self.isFavorite = isFavorite
        self.createdAt = Date()
    }
    
    static func == (lhs: Style, rhs: Style) -> Bool {
        return lhs.id == rhs.id
    }
}

struct CategoryGroup: Identifiable {
    let id = UUID()
    let name: String
    let count: Int
    let type: CategoryType
}

enum CategoryType {
    case category(StyleCategory)
    case length(StyleLength)
    case shape(String)
}

enum SortOption: String, CaseIterable {
    case alphabetical = "Alphabetical"
    case haircuts = "Haircuts"
    case beards = "Beards"
    case favorites = "Favorites"
    
    var displayName: String {
        return self.rawValue
    }
}
