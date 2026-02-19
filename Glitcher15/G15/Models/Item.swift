import Foundation

enum ItemCategory: String, CaseIterable, Identifiable, Codable {
    case documents = "Documents"
    case cosmetics = "Cosmetics"
    case gadgets = "Gadgets"
    case accessories = "Accessories"
    case products = "Products"
    case other = "Other"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        return self.rawValue
    }
}

struct Item: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: ItemCategory
    var note: String
    var isInBag: Bool
    var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case note
        case isInBag
        case createdAt
    }
    
    init(name: String, category: ItemCategory, note: String = "", isInBag: Bool = false) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.note = note
        self.isInBag = isInBag
        self.createdAt = Date()
    }
    
    init(id: UUID, name: String, category: ItemCategory, note: String, isInBag: Bool, createdAt: Date) {
        self.id = id
        self.name = name
        self.category = category
        self.note = note
        self.isInBag = isInBag
        self.createdAt = createdAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(ItemCategory.self, forKey: .category)
        note = try container.decode(String.self, forKey: .note)
        isInBag = try container.decode(Bool.self, forKey: .isInBag)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)
        try container.encode(note, forKey: .note)
        try container.encode(isInBag, forKey: .isInBag)
        try container.encode(createdAt, forKey: .createdAt)
    }
}

struct ItemSet: Identifiable, Codable {
    let id: UUID
    var name: String
    var items: [Item]
    var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case items
        case createdAt
    }
    
    init(name: String, items: [Item] = []) {
        self.id = UUID()
        self.name = name
        self.items = items
        self.createdAt = Date()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        items = try container.decode([Item].self, forKey: .items)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(items, forKey: .items)
        try container.encode(createdAt, forKey: .createdAt)
    }
    
    static let defaultSets = [
        ItemSet(name: "Main Set"),
        ItemSet(name: "Work"),
        ItemSet(name: "Walk"),
        ItemSet(name: "Travel")
    ]
}
