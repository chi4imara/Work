import Foundation

enum RecipeCategory: String, CaseIterable, Identifiable, Codable {
    case scrubs = "Scrubs"
    case hairMasks = "Hair Masks"
    case cosmeticMixes = "Cosmetic Mixes"
    case aromaMixes = "Aroma Mixes"
    case other = "Other"
    
    var id: String { rawValue }
    
    var displayName: String {
        return rawValue
    }
}

struct Recipe: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: RecipeCategory
    var ingredients: String
    var proportions: String
    var process: String
    var notes: String
    var isFavorite: Bool
    let createdDate: Date
    
    init(name: String, category: RecipeCategory, ingredients: String, proportions: String, process: String, notes: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.ingredients = ingredients
        self.proportions = proportions
        self.process = process
        self.notes = notes
        self.isFavorite = false
        self.createdDate = Date()
    }
    
    var shortIngredients: String {
        let components = ingredients.components(separatedBy: "\n")
        let firstTwo = Array(components.prefix(2))
        return firstTwo.joined(separator: ", ")
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: createdDate)
    }
}
