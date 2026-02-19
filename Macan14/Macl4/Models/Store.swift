import Foundation

struct Store: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var type: StoreType
    var category: StoreCategory
    var priceLevel: PriceLevel
    var review: String
    var dateAdded: Date = Date()
    
    init(name: String, type: StoreType, category: StoreCategory, priceLevel: PriceLevel, review: String) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.category = category
        self.priceLevel = priceLevel
        self.review = review
    }
}

enum StoreType: String, CaseIterable, Codable {
    case boutique = "Boutique"
    case online = "Online"
    case department = "Department Store"
    
    var displayName: String {
        return rawValue
    }
}

enum StoreCategory: String, CaseIterable, Codable {
    case clothing = "Clothing"
    case cosmetics = "Cosmetics"
    case shoes = "Shoes"
    case home = "Home"
    case accessories = "Accessories"
    
    var displayName: String {
        return rawValue
    }
}

enum PriceLevel: String, CaseIterable, Codable {
    case low = "$"
    case medium = "$$"
    case high = "$$$"
    
    var displayName: String {
        return rawValue
    }
}
