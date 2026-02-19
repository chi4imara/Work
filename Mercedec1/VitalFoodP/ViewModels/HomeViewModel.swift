import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = Recipe.sampleRecipes
    @Published var filteredRecipes: [Recipe] = Recipe.sampleRecipes
    @Published var selectedMoodFilter: MoodType?
    @Published var selectedDietFilter: DietType?
    @Published var selectedTimeFilter: Int? 
    @Published var savedRecipes: Set<UUID> = []
    
    init() {
        loadSavedRecipes()
    }
    
    func applyFilters() {
        filteredRecipes = recipes.filter { recipe in
            var matches = true
            
            if let moodFilter = selectedMoodFilter {
                matches = matches && recipe.mood == moodFilter
            }
            
            if let timeFilter = selectedTimeFilter {
                matches = matches && recipe.cookingTime <= timeFilter
            }
            
            return matches
        }
    }
    
    func clearFilters() {
        selectedMoodFilter = nil
        selectedDietFilter = nil
        selectedTimeFilter = nil
        filteredRecipes = recipes
    }
    
    func toggleSaveRecipe(_ recipe: Recipe) {
        if savedRecipes.contains(recipe.id) {
            savedRecipes.remove(recipe.id)
        } else {
            savedRecipes.insert(recipe.id)
        }
        saveSavedRecipes()
    }
    
    func isRecipeSaved(_ recipe: Recipe) -> Bool {
        return savedRecipes.contains(recipe.id)
    }
    
    private func loadSavedRecipes() {
        if let data = UserDefaults.standard.data(forKey: "saved_recipes"),
           let savedIds = try? JSONDecoder().decode(Set<UUID>.self, from: data) {
            savedRecipes = savedIds
        }
    }
    
    private func saveSavedRecipes() {
        if let data = try? JSONEncoder().encode(savedRecipes) {
            UserDefaults.standard.set(data, forKey: "saved_recipes")
        }
    }
}
