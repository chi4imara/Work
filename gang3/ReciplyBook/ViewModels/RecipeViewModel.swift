import Foundation
import SwiftUI
import Combine

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var searchText = ""
    @Published var sortOption: SortOption = .name
    @Published var showingAddRecipe = false
    @Published var selectedRecipe: Recipe?
    
    private let userDefaults = UserDefaults.standard
    private let recipesKey = "SavedRecipes"
    
    init() {
        loadRecipes()
    }
    
    var filteredRecipes: [Recipe] {
        let filtered = searchText.isEmpty ? recipes : recipes.filter { recipe in
            recipe.name.localizedCaseInsensitiveContains(searchText)
        }
        
        return sortRecipes(filtered)
    }
    
    private func sortRecipes(_ recipes: [Recipe]) -> [Recipe] {
        switch sortOption {
        case .name:
            return recipes.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
        case .dateAdded:
            return recipes.sorted { $0.dateAdded > $1.dateAdded }
        case .cookingTime:
            return recipes.sorted { 
                let time1 = $0.cookingTime ?? Int.max
                let time2 = $1.cookingTime ?? Int.max
                return time1 < time2
            }
        }
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
    
    func deleteAllRecipes() {
        recipes.removeAll()
        saveRecipes()
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
