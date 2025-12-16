import Foundation
import SwiftUI
import Combine

class RecipeStore: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: String? = nil
    
    private let userDefaults = UserDefaults.standard
    private let recipesKey = "SavedRecipes"
    
    init() {
        loadRecipes()
    }
    
    var filteredRecipes: [Recipe] {
        var filtered = recipes
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { recipe in
                recipe.title.localizedCaseInsensitiveContains(searchText) ||
                recipe.ingredients.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered.sorted { $0.dateModified > $1.dateModified }
    }
    
    func getRecipesCount(for category: String) -> Int {
        return recipes.filter { $0.category == category }.count
    }
    
    func getRecipes(for category: String) -> [Recipe] {
        return recipes.filter { $0.category == category }
            .sorted { $0.dateModified > $1.dateModified }
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
    
    func getRecipe(by id: UUID) -> Recipe? {
        return recipes.first { $0.id == id }
    }
    
    private func saveRecipes() {
        if let encoded = try? JSONEncoder().encode(recipes) {
            userDefaults.set(encoded, forKey: recipesKey)
        }
    }
    
    private func loadRecipes() {
        if let data = userDefaults.data(forKey: recipesKey),
           let decodedRecipes = try? JSONDecoder().decode([Recipe].self, from: data) {
            recipes = decodedRecipes
        }
    }
}
