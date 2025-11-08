import Foundation

struct Recipe: Identifiable, Codable {
    let id: UUID
    var title: String
    var category: RecipeCategory
    var ingredients: [String]
    var instructions: String
    var createdAt: Date
    var updatedAt: Date
    var isFavorite: Bool
    
    init(title: String, category: RecipeCategory = .other, ingredients: [String] = [], instructions: String = "", isFavorite: Bool = false) {
        self.id = UUID()
        self.title = title
        self.category = category
        self.ingredients = ingredients
        self.instructions = instructions
        self.createdAt = Date()
        self.updatedAt = Date()
        self.isFavorite = isFavorite
    }
}

enum RecipeCategory: String, CaseIterable, Codable {
    case soups = "Soups"
    case salads = "Salads"
    case baking = "Baking"
    case desserts = "Desserts"
    case drinks = "Drinks"
    case other = "Other"
    case custom = "Custom"
    
    var displayName: String {
        return self.rawValue
    }
    
    static var allCases: [RecipeCategory] {
        return [.soups, .salads, .baking, .desserts, .drinks, .other, .custom]
    }
}

struct CustomCategory: Identifiable, Codable {
    let id: UUID
    let name: String
    let createdAt: Date
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
    }
}
