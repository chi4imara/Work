import Foundation

enum ProductResult: String, CaseIterable, Codable {
    case liked = "Liked"
    case neutral = "Neutral" 
    case disliked = "Disliked"
    
    var displayName: String {
        return self.rawValue
    }
}

enum ProductCategory: String, CaseIterable, Codable {
    case skincare = "Skincare"
    case makeup = "Makeup"
    case cleansing = "Cleansing"
    case fragrance = "Fragrance"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
}

struct Product: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var category: ProductCategory
    var firstUseDate: Date
    var result: ProductResult
    var notes: String
    var isFavorite: Bool
    
    init(name: String, category: ProductCategory, firstUseDate: Date, result: ProductResult, notes: String = "", isFavorite: Bool = false) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.firstUseDate = firstUseDate
        self.result = result
        self.notes = notes
        self.isFavorite = isFavorite
    }
}

struct CategoryInfo {
    let category: ProductCategory
    let productCount: Int
}
