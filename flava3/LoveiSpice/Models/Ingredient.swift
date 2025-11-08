import Foundation

struct IngredientItem: Identifiable {
    let id = UUID()
    let name: String
    let recipeCount: Int
    var isPurchased: Bool = false
}

struct RecipeIngredient: Identifiable {
    let id = UUID()
    let name: String
    let recipeId: UUID
    var isUsed: Bool = false
}
