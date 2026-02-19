import Foundation

struct Purchase: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var category: PurchaseCategory
    var plannedAmount: Double
    var actualAmount: Double?
    var date: Date
    var notes: String
    var isCompleted: Bool
    var photos: [String]
    var createdAt: Date
    var updatedAt: Date
    
    init(name: String, category: PurchaseCategory, plannedAmount: Double, date: Date = Date(), notes: String = "", id: UUID = UUID()) {
        self.id = id
        self.name = name
        self.category = category
        self.plannedAmount = plannedAmount
        self.date = date
        self.notes = notes
        self.isCompleted = false
        self.photos = []
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, category, plannedAmount, actualAmount, date, notes, isCompleted, photos, createdAt, updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        category = try c.decode(PurchaseCategory.self, forKey: .category)
        plannedAmount = try c.decode(Double.self, forKey: .plannedAmount)
        actualAmount = try c.decodeIfPresent(Double.self, forKey: .actualAmount)
        date = try c.decode(Date.self, forKey: .date)
        notes = try c.decode(String.self, forKey: .notes)
        isCompleted = try c.decode(Bool.self, forKey: .isCompleted)
        photos = try c.decode([String].self, forKey: .photos)
        createdAt = try c.decode(Date.self, forKey: .createdAt)
        updatedAt = try c.decode(Date.self, forKey: .updatedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(name, forKey: .name)
        try c.encode(category, forKey: .category)
        try c.encode(plannedAmount, forKey: .plannedAmount)
        try c.encodeIfPresent(actualAmount, forKey: .actualAmount)
        try c.encode(date, forKey: .date)
        try c.encode(notes, forKey: .notes)
        try c.encode(isCompleted, forKey: .isCompleted)
        try c.encode(photos, forKey: .photos)
        try c.encode(createdAt, forKey: .createdAt)
        try c.encode(updatedAt, forKey: .updatedAt)
    }
    
    mutating func markAsCompleted(actualAmount: Double? = nil) {
        self.isCompleted = true
        self.actualAmount = actualAmount ?? self.plannedAmount
        self.updatedAt = Date()
    }
    
    mutating func update() {
        self.updatedAt = Date()
    }
    
    var finalAmount: Double {
        return actualAmount ?? plannedAmount
    }
    
    var savingsAmount: Double {
        guard let actualAmount = actualAmount else { return 0 }
        return plannedAmount - actualAmount
    }
    
    var isOverBudget: Bool {
        guard let actualAmount = actualAmount else { return false }
        return actualAmount > plannedAmount
    }
}

enum PurchaseCategory: String, CaseIterable, Codable {
    case clothing = "Clothing"
    case cosmetics = "Cosmetics"
    case home = "Home"
    case gifts = "Gifts"
    
    var icon: String {
        switch self {
        case .clothing: return "tshirt"
        case .cosmetics: return "paintbrush"
        case .home: return "house"
        case .gifts: return "gift"
        }
    }
    
    var color: String {
        switch self {
        case .clothing: return "softPink"
        case .cosmetics: return "lightYellow"
        case .home: return "lightGreen"
        case .gifts: return "softPurple"
        }
    }
}
