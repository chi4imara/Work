import Foundation

struct WardrobeItem: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: String
    var description: String
    var isPurchased: Bool
    var createdAt: Date
    
    init(name: String, category: String, description: String = "", isPurchased: Bool = false) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.description = description
        self.isPurchased = isPurchased
        self.createdAt = Date()
    }
}

extension WardrobeItem {
    static let defaultCategories = [
        "Tops",
        "Bottoms", 
        "Shoes",
        "Dresses",
        "Accessories"
    ]
}
