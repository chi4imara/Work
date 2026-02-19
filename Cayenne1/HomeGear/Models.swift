import Foundation

enum ItemCategory: String, CaseIterable, Identifiable {
    case tools = "Tools"
    case gadgets = "Gadgets"
    case parts = "Parts"
    case equipment = "Equipment"
    case accessories = "Accessories"
    case other = "Other"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .tools: return "Tools"
        case .gadgets: return "Gadgets"
        case .parts: return "Parts"
        case .equipment: return "Equipment"
        case .accessories: return "Accessories"
        case .other: return "Other"
        }
    }
}

enum ItemStatus: String, CaseIterable, Identifiable {
    case working = "Working"
    case needsCheck = "Needs Check"
    case broken = "Broken"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .working: return "Working"
        case .needsCheck: return "Needs Check"
        case .broken: return "Broken"
        }
    }
}

struct InventoryItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: ItemCategory
    var location: String
    var status: ItemStatus
    var comment: String
    var dateCreated: Date
    var dateModified: Date
    
    init(name: String, category: ItemCategory, location: String, status: ItemStatus, comment: String) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.location = location
        self.status = status
        self.comment = comment
        self.dateCreated = Date()
        self.dateModified = Date()
    }
    
    init(id: UUID, name: String, category: ItemCategory, location: String, status: ItemStatus, comment: String, dateCreated: Date, dateModified: Date) {
        self.id = id
        self.name = name
        self.category = category
        self.location = location
        self.status = status
        self.comment = comment
        self.dateCreated = dateCreated
        self.dateModified = dateModified
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, category, location, status, comment, dateCreated, dateModified
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let categoryString = try container.decode(String.self, forKey: .category)
        category = ItemCategory(rawValue: categoryString) ?? .other
        location = try container.decode(String.self, forKey: .location)
        let statusString = try container.decode(String.self, forKey: .status)
        status = ItemStatus(rawValue: statusString) ?? .working
        comment = try container.decode(String.self, forKey: .comment)
        dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        dateModified = try container.decode(Date.self, forKey: .dateModified)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(category.rawValue, forKey: .category)
        try container.encode(location, forKey: .location)
        try container.encode(status.rawValue, forKey: .status)
        try container.encode(comment, forKey: .comment)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(dateModified, forKey: .dateModified)
    }
    
    mutating func updateModifiedDate() {
        self.dateModified = Date()
    }
}

struct Note: Identifiable, Codable {
    let id: UUID
    var content: String
    var dateCreated: Date
    var dateModified: Date
    
    init(content: String) {
        self.id = UUID()
        self.content = content
        self.dateCreated = Date()
        self.dateModified = Date()
    }
    
    init(id: UUID, content: String, dateCreated: Date, dateModified: Date) {
        self.id = id
        self.content = content
        self.dateCreated = dateCreated
        self.dateModified = dateModified
    }
    
    enum CodingKeys: String, CodingKey {
        case id, content, dateCreated, dateModified
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        content = try container.decode(String.self, forKey: .content)
        dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        dateModified = try container.decode(Date.self, forKey: .dateModified)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(content, forKey: .content)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(dateModified, forKey: .dateModified)
    }
    
    mutating func updateModifiedDate() {
        self.dateModified = Date()
    }
    
    var preview: String {
        let lines = content.components(separatedBy: .newlines)
        let firstLine = lines.first ?? ""
        return firstLine.count > 50 ? String(firstLine.prefix(50)) + "..." : firstLine
    }
}

struct CategoryStats {
    let category: ItemCategory
    let count: Int
}

struct StatusStats {
    let status: ItemStatus
    let count: Int
}
