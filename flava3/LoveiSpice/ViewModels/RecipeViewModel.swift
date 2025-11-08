import Foundation
import SwiftUI
import Combine

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: RecipeCategory? = nil
    @Published var ingredientStates: [UUID: [String: Bool]] = [:]
    @Published var customCategories: [CustomCategory] = []
    @Published var purchasedIngredients: [String: Bool] = [:]
    
    private let userDefaults = UserDefaults.standard
    private let recipesKey = "SavedRecipes"
    private let ingredientStatesKey = "IngredientStates"
    private let customCategoriesKey = "CustomCategories"
    private let purchasedIngredientsKey = "PurchasedIngredients"
    
    init() {
        loadRecipes()
        loadIngredientStates()
        loadCustomCategories()
        loadPurchasedIngredients()
    }
    
    func addRecipe(_ recipe: Recipe) {
        recipes.insert(recipe, at: 0)
        saveRecipes()
    }
    
    func updateRecipe(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            var updatedRecipe = recipe
            updatedRecipe.updatedAt = Date()
            recipes[index] = updatedRecipe
            
            recipes.remove(at: index)
            recipes.insert(updatedRecipe, at: 0)
            
            saveRecipes()
        }
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        recipes.removeAll { $0.id == recipe.id }
        ingredientStates.removeValue(forKey: recipe.id)
        saveRecipes()
        saveIngredientStates()
    }
    
    func clearAllRecipes() {
        recipes.removeAll()
        ingredientStates.removeAll()
        saveRecipes()
        saveIngredientStates()
    }
    
    var filteredRecipes: [Recipe] {
        var filtered = recipes
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { recipe in
                recipe.title.localizedCaseInsensitiveContains(searchText) ||
                recipe.ingredients.joined(separator: " ").localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    func clearFilters() {
        searchText = ""
        selectedCategory = nil
    }
    
    func toggleIngredientState(for recipeId: UUID, ingredient: String) {
        if ingredientStates[recipeId] == nil {
            ingredientStates[recipeId] = [:]
        }
        
        let currentState = ingredientStates[recipeId]?[ingredient] ?? false
        ingredientStates[recipeId]?[ingredient] = !currentState
        
        saveIngredientStates()
    }
    
    func isIngredientUsed(recipeId: UUID, ingredient: String) -> Bool {
        return ingredientStates[recipeId]?[ingredient] ?? false
    }
    
    func getIngredientsList() -> [IngredientItem] {
        var ingredientCounts: [String: Int] = [:]
        var ingredientStates: [String: Bool] = [:]
        
        for recipe in recipes {
            for ingredient in recipe.ingredients {
                let trimmedIngredient = ingredient.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmedIngredient.isEmpty {
                    ingredientCounts[trimmedIngredient] = (ingredientCounts[trimmedIngredient] ?? 0) + 1
                    
                    let isUsedInAnyRecipe = recipes.contains { recipe in
                        isIngredientUsed(recipeId: recipe.id, ingredient: trimmedIngredient)
                    }
                    ingredientStates[trimmedIngredient] = isUsedInAnyRecipe
                }
            }
        }
        
        return ingredientCounts.map { name, count in
            IngredientItem(name: name, recipeCount: count, isPurchased: ingredientStates[name] ?? false)
        }.sorted { $0.name < $1.name }
    }
    
    func toggleGlobalIngredientState(_ ingredientName: String) {
        let newState = !isGlobalIngredientPurchased(ingredientName)
        
        for recipe in recipes {
            if recipe.ingredients.contains(where: { $0.trimmingCharacters(in: .whitespacesAndNewlines) == ingredientName }) {
                if ingredientStates[recipe.id] == nil {
                    ingredientStates[recipe.id] = [:]
                }
                ingredientStates[recipe.id]?[ingredientName] = newState
            }
        }
        
        saveIngredientStates()
    }
    
    func isGlobalIngredientPurchased(_ ingredientName: String) -> Bool {
        return recipes.contains { recipe in
            isIngredientUsed(recipeId: recipe.id, ingredient: ingredientName)
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
    
    private func saveIngredientStates() {
        if let encoded = try? JSONEncoder().encode(ingredientStates) {
            userDefaults.set(encoded, forKey: ingredientStatesKey)
        }
    }
    
    private func loadIngredientStates() {
        if let data = userDefaults.data(forKey: ingredientStatesKey),
           let decoded = try? JSONDecoder().decode([UUID: [String: Bool]].self, from: data) {
            ingredientStates = decoded
        }
    }
    
    func addCustomCategory(_ name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        if customCategories.contains(where: { $0.name.lowercased() == trimmedName.lowercased() }) {
            return
        }
        
        let newCategory = CustomCategory(name: trimmedName)
        customCategories.append(newCategory)
        saveCustomCategories()
    }
    
    func deleteCustomCategory(_ category: CustomCategory) {
        customCategories.removeAll { $0.id == category.id }
        saveCustomCategories()
    }
    
    func getAllCategories() -> [RecipeCategory] {
        return RecipeCategory.allCases
    }
    
    func getAllCustomCategories() -> [CustomCategory] {
        return customCategories.sorted { $0.name < $1.name }
    }
    
    private func saveCustomCategories() {
        if let encoded = try? JSONEncoder().encode(customCategories) {
            userDefaults.set(encoded, forKey: customCategoriesKey)
        }
    }
    
    private func loadCustomCategories() {
        if let data = userDefaults.data(forKey: customCategoriesKey),
           let decoded = try? JSONDecoder().decode([CustomCategory].self, from: data) {
            customCategories = decoded
        }
    }
    
    func toggleFavorite(for recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index].isFavorite.toggle()
            recipes[index].updatedAt = Date()
            saveRecipes()
        }
    }
    
    func addToFavorites(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index].isFavorite = true
            recipes[index].updatedAt = Date()
            saveRecipes()
        }
    }
    
    func removeFromFavorites(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index].isFavorite = false
            recipes[index].updatedAt = Date()
            saveRecipes()
        }
    }
    
    var favoriteRecipes: [Recipe] {
        return recipes.filter { $0.isFavorite }
    }
    
    func togglePurchasedState(for ingredient: String) {
        purchasedIngredients[ingredient] = !isIngredientPurchased(ingredient)
        savePurchasedIngredients()
    }
    
    func isIngredientPurchased(_ ingredient: String) -> Bool {
        return purchasedIngredients[ingredient] ?? false
    }
    
    func markIngredientAsPurchased(_ ingredient: String) {
        purchasedIngredients[ingredient] = true
        savePurchasedIngredients()
    }
    
    func markIngredientAsNotPurchased(_ ingredient: String) {
        purchasedIngredients[ingredient] = false
        savePurchasedIngredients()
    }
    
    private func savePurchasedIngredients() {
        if let encoded = try? JSONEncoder().encode(purchasedIngredients) {
            userDefaults.set(encoded, forKey: purchasedIngredientsKey)
        }
    }
    
    private func loadPurchasedIngredients() {
        if let data = userDefaults.data(forKey: purchasedIngredientsKey),
           let decoded = try? JSONDecoder().decode([String: Bool].self, from: data) {
            purchasedIngredients = decoded
        }
    }
}
