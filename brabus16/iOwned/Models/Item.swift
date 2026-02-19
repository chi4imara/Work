import Foundation

struct Item: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: ItemCategory
    var characteristics: String
    var notes: String
    var dateCreated: Date
    var dateModified: Date
    
    init(name: String, category: ItemCategory, characteristics: String = "", notes: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.characteristics = characteristics
        self.notes = notes
        self.dateCreated = Date()
        self.dateModified = Date()
    }
    
    mutating func update(name: String, category: ItemCategory, characteristics: String, notes: String) {
        self.name = name
        self.category = category
        self.characteristics = characteristics
        self.notes = notes
        self.dateModified = Date()
    }
}

enum ItemCategory: String, CaseIterable, Codable {
    case tools = "Tools"
    case electronics = "Electronics"
    case clothing = "Clothing"
    case accessories = "Accessories"
    
    var displayName: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .tools:
            return "wrench.and.screwdriver"
        case .electronics:
            return "laptopcomputer"
        case .clothing:
            return "tshirt"
        case .accessories:
            return "bag"
        }
    }
}
