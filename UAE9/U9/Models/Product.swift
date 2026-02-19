import Foundation

enum ProductCategory: String, CaseIterable, Identifiable, Codable {
    case cream = "Cream"
    case oil = "Oil"
    case shampoo = "Shampoo"
    case balm = "Balm"
    case gel = "Gel"
    case other = "Other"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .cream: return "drop.fill"
        case .oil: return "drop.circle.fill"
        case .shampoo: return "bubbles.and.sparkles.fill"
        case .balm: return "leaf.fill"
        case .gel: return "water.waves"
        case .other: return "cube.fill"
        }
    }
}

enum ProductStatus: String, CaseIterable, Identifiable, Codable {
    case inUse = "In Use"
    case runningOut = "Running Out"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        return self.rawValue
    }
}

enum StockLevel: String, CaseIterable, Identifiable, Codable {
    case normal = "Normal"
    case medium = "Medium"
    case low = "Low"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        return self.rawValue
    }
    
    var priority: Int {
        switch self {
        case .low: return 3
        case .medium: return 2
        case .normal: return 1
        }
    }
}

struct Product: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: ProductCategory
    var status: ProductStatus
    var lastUsed: Date
    var stockLevel: StockLevel
    var notes: String
    var createdAt: Date
    var updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case status
        case lastUsed
        case stockLevel
        case notes
        case createdAt
        case updatedAt
    }
    
    init(name: String, category: ProductCategory, status: ProductStatus = .inUse, lastUsed: Date = Date(), stockLevel: StockLevel = .normal, notes: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.status = status
        self.lastUsed = lastUsed
        self.stockLevel = stockLevel
        self.notes = notes
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(ProductCategory.self, forKey: .category)
        status = try container.decode(ProductStatus.self, forKey: .status)
        lastUsed = try container.decode(Date.self, forKey: .lastUsed)
        stockLevel = try container.decode(StockLevel.self, forKey: .stockLevel)
        notes = try container.decode(String.self, forKey: .notes)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)
        try container.encode(status, forKey: .status)
        try container.encode(lastUsed, forKey: .lastUsed)
        try container.encode(stockLevel, forKey: .stockLevel)
        try container.encode(notes, forKey: .notes)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
    
    var daysSinceLastUsed: Int {
        Calendar.current.dateComponents([.day], from: lastUsed, to: Date()).day ?? 0
    }
    
    var lastUsedText: String {
        let days = daysSinceLastUsed
        if days == 0 {
            return "Today"
        } else if days == 1 {
            return "1 day ago"
        } else {
            return "\(days) days ago"
        }
    }
    
    mutating func markAsUsed() {
        self.lastUsed = Date()
        self.updatedAt = Date()
    }
    
    mutating func updateStatus(_ newStatus: ProductStatus, stockLevel: StockLevel) {
        self.status = newStatus
        self.stockLevel = stockLevel
        self.updatedAt = Date()
    }
}

extension Product {
    static let sampleProducts: [Product] = [
        Product(name: "Beard Oil", category: .oil, status: .inUse, stockLevel: .medium, notes: "Use after shower"),
        Product(name: "Face Cream", category: .cream, status: .runningOut, stockLevel: .low, notes: "Morning routine"),
        Product(name: "Hair Shampoo", category: .shampoo, status: .inUse, stockLevel: .normal, notes: "Daily use"),
        Product(name: "Moisturizing Balm", category: .balm, status: .inUse, stockLevel: .medium, notes: "For dry skin"),
        Product(name: "Styling Gel", category: .gel, status: .runningOut, stockLevel: .low, notes: "Special occasions")
    ]
}
