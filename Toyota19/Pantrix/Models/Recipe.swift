import Foundation

struct Recipe: Identifiable, Codable {
    var id: UUID
    var name: String
    var cookingTime: Int
    var ingredients: [String]
    var instructions: [String]
    var category: RecipeCategory
    var isFavorite: Bool = false
    var isCooked: Bool = false
    var dateCooked: Date?
    
    init(
        id: UUID = UUID(),
        name: String,
        cookingTime: Int,
        ingredients: [String],
        instructions: [String],
        category: RecipeCategory,
        isFavorite: Bool = false,
        isCooked: Bool = false,
        dateCooked: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.cookingTime = cookingTime
        self.ingredients = ingredients
        self.instructions = instructions
        self.category = category
        self.isFavorite = isFavorite
        self.isCooked = isCooked
        self.dateCooked = dateCooked
    }
    
    enum RecipeCategory: String, CaseIterable, Codable {
        case quick = "Quick"
        case protein = "Protein"
        case sweet = "Sweet"
        case healthy = "Healthy"
        
        var displayName: String {
            return self.rawValue
        }
    }
}
