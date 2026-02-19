import Foundation

enum ItemCategory: String, CaseIterable, Identifiable, Codable {
    case tools = "Tools"
    case carCare = "Car Care"
    case spareParts = "Spare Parts"
    case other = "Other"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .tools: return "Tools"
        case .carCare: return "Car Care"
        case .spareParts: return "Spare Parts"
        case .other: return "Other"
        }
    }
}

struct GarageItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: ItemCategory
    var location: String
    var condition: String
    var comment: String
    var dateCreated: Date
    var dateModified: Date
    
    init(name: String, category: ItemCategory, location: String, condition: String, comment: String) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.location = location
        self.condition = condition
        self.comment = comment
        self.dateCreated = Date()
        self.dateModified = Date()
    }
    
    mutating func updateModifiedDate() {
        self.dateModified = Date()
    }
}

struct Location: Identifiable, Codable {
    let id: UUID
    let name: String
    var itemCount: Int
    
    init(name: String, itemCount: Int = 0) {
        self.id = UUID()
        self.name = name
        self.itemCount = itemCount
    }
}

enum FilterType: String, CaseIterable {
    case all = "All"
    case tools = "Tools"
    case carCare = "Car Care"
    case spareParts = "Spare Parts"
    
    var category: ItemCategory? {
        switch self {
        case .all: return nil
        case .tools: return .tools
        case .carCare: return .carCare
        case .spareParts: return .spareParts
        }
    }
}
