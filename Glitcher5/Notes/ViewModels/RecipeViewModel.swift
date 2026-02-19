import Foundation
import SwiftUI
import Combine

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var currentRecipe: Recipe?
    
    private let userDefaults = UserDefaults.standard
    private let recipesKey = "SavedRecipes"
    
    init() {
        loadRecipes()
    }
    
    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
        saveRecipes()
    }
    
    func updateRecipe(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index] = recipe
            saveRecipes()
        }
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        recipes.removeAll { $0.id == recipe.id }
        saveRecipes()
    }
    
    func deleteRecipe(at indexSet: IndexSet) {
        recipes.remove(atOffsets: indexSet)
        saveRecipes()
    }
    
    func getRecipesByMeatType() -> [String: [Recipe]] {
        Dictionary(grouping: recipes) { $0.meatType }
    }
    
    func getRecipesForMeatType(_ meatType: String) -> [Recipe] {
        recipes.filter { $0.meatType == meatType }
    }
    
    func getMeatTypesWithCounts() -> [(type: String, count: Int)] {
        let grouped = getRecipesByMeatType()
        return grouped.map { (type: $0.key, count: $0.value.count) }
            .sorted { $0.type < $1.type }
    }
    
    private func saveRecipes() {
        if let encoded = try? JSONEncoder().encode(recipes) {
            userDefaults.set(encoded, forKey: recipesKey)
        }
    }
    
    private func loadRecipes() {
        if let data = userDefaults.data(forKey: recipesKey),
           var decoded = try? JSONDecoder().decode([Recipe].self, from: data) {
            for i in 0..<decoded.count {
            }
            recipes = decoded
        }
    }
    
    func toggleFavorite(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index].isFavorite.toggle()
            saveRecipes()
        }
    }
    
    func getFavoriteRecipes() -> [Recipe] {
        recipes.filter { $0.isFavorite }
    }
    
    func isValidRecipe(dishName: String, meatType: String, cookingTime: String, sauceMarinate: String, cookingStep: String) -> Bool {
        return !dishName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !meatType.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !cookingTime.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !sauceMarinate.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !cookingStep.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
