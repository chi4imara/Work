import Foundation

enum Season: String, CaseIterable, Codable {
    case spring = "Spring"
    case summer = "Summer"
    case autumn = "Autumn"
    case winter = "Winter"
    
    var displayName: String {
        return rawValue
    }
}

enum Category: String, CaseIterable, Codable {
    case outerwear = "Outerwear"
    case shoes = "Shoes"
    case accessories = "Accessories"
    case undergarments = "Undergarments"
    case other = "Other"
    
    var displayName: String {
        return rawValue
    }
}

enum ItemStatus: String, CaseIterable, Codable {
    case inUse = "In Use"
    case store = "Store"
    case buy = "Buy"
    
    var displayName: String {
        return rawValue
    }
}

struct WardrobeItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: Category
    var season: Season
    var status: ItemStatus
    var comment: String
    let dateCreated: Date
    
    init(name: String, category: Category, season: Season, status: ItemStatus = .inUse, comment: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.season = season
        self.status = status
        self.comment = comment
        self.dateCreated = Date()
    }
}

struct Note: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    let dateCreated: Date
    
    init(title: String, content: String) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.dateCreated = Date()
    }
}

enum ItemFilter: String, CaseIterable {
    case all = "All"
    case inUse = "In Use"
    case store = "Store"
    case buy = "Buy"
    
    var displayName: String {
        return rawValue
    }
}
