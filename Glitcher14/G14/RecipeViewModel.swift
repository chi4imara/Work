import Foundation
import SwiftUI
import Combine

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var searchText = ""
    
    private let userDefaults = UserDefaults.standard
    private let recipesKey = "SavedRecipes"
    
    init() {
        loadRecipes()
    }
    
    var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return recipes
        } else {
            return recipes.filter { recipe in
                recipe.name.localizedCaseInsensitiveContains(searchText) ||
                recipe.ingredients.localizedCaseInsensitiveContains(searchText) ||
                recipe.category.displayName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var favoriteRecipes: [Recipe] {
        return recipes.filter { $0.isFavorite }
    }
    
    var categoriesWithCount: [(category: RecipeCategory, count: Int)] {
        let categories = RecipeCategory.allCases
        return categories.compactMap { category in
            let count = recipes.filter { $0.category == category }.count
            return count > 0 ? (category, count) : nil
        }
    }
    
    func recipes(for category: RecipeCategory) -> [Recipe] {
        return recipes.filter { $0.category == category }
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
    
    func toggleFavorite(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index].isFavorite.toggle()
            saveRecipes()
        }
    }
    
    private func saveRecipes() {
        if let encoded = try? JSONEncoder().encode(recipes) {
            userDefaults.set(encoded, forKey: recipesKey)
        }
    }
    
    private func loadRecipes() {
        if let data = userDefaults.data(forKey: recipesKey),
           let decoded = try? JSONDecoder().decode([Recipe].self, from: data) {
            recipes = decoded
        }
    }
}
