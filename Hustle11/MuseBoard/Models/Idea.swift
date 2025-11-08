import Foundation

struct Idea: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
    var description: String
    var category: Category
    var tags: [Tag]
    var notes: String
    var isFavorite: Bool
    var dateCreated: Date
    var dateModified: Date
    
    init(title: String, description: String, category: Category, tags: [Tag] = [], notes: String = "", isFavorite: Bool = false) {
        self.title = title
        self.description = description
        self.category = category
        self.tags = tags
        self.notes = notes
        self.isFavorite = isFavorite
        self.dateCreated = Date()
        self.dateModified = Date()
    }
    
    mutating func updateModifiedDate() {
        self.dateModified = Date()
    }
}

enum Category: String, CaseIterable, Codable {
    case work = "Work"
    case hobby = "Hobby"
    case travel = "Travel"
    case family = "Family"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
    
    var iconName: String {
        switch self {
        case .work:
            return "briefcase"
        case .hobby:
            return "gamecontroller"
        case .travel:
            return "airplane"
        case .family:
            return "house"
        case .other:
            return "folder"
        }
    }
}

struct Tag: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var color: String
    
    init(name: String, color: String = "#007AFF") {
        self.name = name
        self.color = color
    }
}

enum SortOption: String, CaseIterable {
    case dateCreated = "Date Created"
    case alphabetical = "Alphabetical"
    case category = "Category"
    
    var displayName: String {
        return self.rawValue
    }
}
