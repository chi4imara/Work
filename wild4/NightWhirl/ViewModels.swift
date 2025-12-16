import Foundation
import SwiftUI
import Combine

class RecipeManager: ObservableObject {
    @Published var todayRecipe: Recipe?
    @Published var favoriteRecipes: [Recipe] = []
    @Published var recipeHistory: [Recipe] = []
    @Published var allRecipes: [Recipe] = []
    @Published var isLoading = false
    @Published var showToast = false
    @Published var toastMessage = ""
    @Published var checkedIngredients: [UUID: Set<UUID>] = [:]
    
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "FavoriteRecipes"
    private let historyKey = "RecipeHistory"
    private let todayRecipeKey = "TodayRecipe"
    private let lastDateKey = "LastRecipeDate"
    private let allRecipesKey = "AllRecipes"
    private let checkedIngredientsKey = "CheckedIngredients"
    
    init() {
        loadAllRecipes()
        loadFavorites()
        loadHistory()
        loadTodayRecipe()
        loadCheckedIngredients()
    }
    
    private func loadAllRecipes() {
        if let data = userDefaults.data(forKey: allRecipesKey),
           let recipes = try? JSONDecoder().decode([Recipe].self, from: data) {
            allRecipes = recipes
        } else {
            allRecipes = []
            saveAllRecipes()
        }
    }
    
    private func saveAllRecipes() {
        if let data = try? JSONEncoder().encode(allRecipes) {
            userDefaults.set(data, forKey: allRecipesKey)
        }
    }
    
    func addRecipe(_ recipe: Recipe) {
        allRecipes.append(recipe)
        saveAllRecipes()
        showToast(message: "Recipe added successfully")
        
        if let recipeDate = recipe.date, Calendar.current.isDateInToday(recipeDate) {
            checkAndUpdateTodayRecipe()
        }
    }
    
    func updateRecipe(_ recipe: Recipe) {
        if let index = allRecipes.firstIndex(where: { $0.id == recipe.id }) {
            allRecipes[index] = recipe
            saveAllRecipes()
            
            if todayRecipe?.id == recipe.id {
                todayRecipe = recipe
                saveTodayRecipe(recipe)
            }
            
            if let favoriteIndex = favoriteRecipes.firstIndex(where: { $0.id == recipe.id }) {
                favoriteRecipes[favoriteIndex] = recipe
                saveFavorites()
            }
            
            if let historyIndex = recipeHistory.firstIndex(where: { $0.id == recipe.id }) {
                recipeHistory[historyIndex] = recipe
                saveHistory()
            }
            
            showToast(message: "Recipe updated successfully")
        }
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        allRecipes.removeAll { $0.id == recipe.id }
        removeFavorite(recipe)
        saveAllRecipes()
        showToast(message: "Recipe deleted")
    }
    
    func loadTodayRecipe() {
        let today = Calendar.current.startOfDay(for: Date())
        let lastDate = userDefaults.object(forKey: lastDateKey) as? Date ?? Date.distantPast
        
        if Calendar.current.isDate(today, inSameDayAs: lastDate) {
            if let data = userDefaults.data(forKey: todayRecipeKey),
               let recipe = try? JSONDecoder().decode(Recipe.self, from: data) {
                todayRecipe = recipe
                return
            }
        }
        
        if let recipeWithTodayDate = findRecipeForToday() {
            todayRecipe = recipeWithTodayDate
            saveTodayRecipe(recipeWithTodayDate)
            return
        }
        
        generateTodayRecipe()
    }
    
    private func findRecipeForToday() -> Recipe? {
        let today = Calendar.current.startOfDay(for: Date())
        return allRecipes.first { recipe in
            if let recipeDate = recipe.date {
                return Calendar.current.isDate(recipeDate, inSameDayAs: today)
            }
            return false
        }
    }
    
    func checkAndUpdateTodayRecipe() {
        if let recipeWithTodayDate = findRecipeForToday() {
            todayRecipe = recipeWithTodayDate
            saveTodayRecipe(recipeWithTodayDate)
        }
    }
    
    private func generateTodayRecipe() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let availableRecipes = self.allRecipes.filter { recipe in
                !self.recipeHistory.contains { $0.id == recipe.id }
            }
            
            if let newRecipe = availableRecipes.randomElement() {
                let todayRecipe = Recipe(
                    name: newRecipe.name,
                    description: newRecipe.description,
                    imageName: newRecipe.imageName,
                    imageFileName: newRecipe.imageFileName,
                    ingredients: newRecipe.ingredients,
                    instructions: newRecipe.instructions,
                    category: newRecipe.category,
                    cookingTime: newRecipe.cookingTime,
                    difficulty: newRecipe.difficulty,
                    date: Date()
                )
                
                self.todayRecipe = todayRecipe
                self.saveTodayRecipe(todayRecipe)
                
                self.moveYesterdayRecipeToHistory()
            } else if self.allRecipes.isEmpty == false {
                let newRecipe = self.allRecipes.randomElement()!
                let todayRecipe = Recipe(
                    name: newRecipe.name,
                    description: newRecipe.description,
                    imageName: newRecipe.imageName,
                    imageFileName: newRecipe.imageFileName,
                    ingredients: newRecipe.ingredients,
                    instructions: newRecipe.instructions,
                    category: newRecipe.category,
                    cookingTime: newRecipe.cookingTime,
                    difficulty: newRecipe.difficulty,
                    date: Date()
                )
                
                self.todayRecipe = todayRecipe
                self.saveTodayRecipe(todayRecipe)
            }
            
            self.isLoading = false
        }
    }
    
    private func saveTodayRecipe(_ recipe: Recipe) {
        if let data = try? JSONEncoder().encode(recipe) {
            userDefaults.set(data, forKey: todayRecipeKey)
            userDefaults.set(Date(), forKey: lastDateKey)
        }
    }
    
    private func moveYesterdayRecipeToHistory() {
    }
    
    func toggleFavorite(_ recipe: Recipe) {
        if isFavorite(recipe) {
            removeFavorite(recipe)
        } else {
            addFavorite(recipe)
        }
    }
    
    func addFavorite(_ recipe: Recipe) {
        if !favoriteRecipes.contains(where: { $0.id == recipe.id }) {
            favoriteRecipes.insert(recipe, at: 0)
            saveFavorites()
            showToast(message: "Added to favorites")
        }
    }
    
    func removeFavorite(_ recipe: Recipe) {
        favoriteRecipes.removeAll { $0.id == recipe.id }
        saveFavorites()
        showToast(message: "Removed from favorites")
    }
    
    func isFavorite(_ recipe: Recipe) -> Bool {
        favoriteRecipes.contains { $0.id == recipe.id }
    }
    
    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favoriteRecipes) {
            userDefaults.set(data, forKey: favoritesKey)
        }
    }
    
    private func loadFavorites() {
        if let data = userDefaults.data(forKey: favoritesKey),
           let recipes = try? JSONDecoder().decode([Recipe].self, from: data) {
            favoriteRecipes = recipes
        }
    }
    
    private func saveHistory() {
        if let data = try? JSONEncoder().encode(recipeHistory) {
            userDefaults.set(data, forKey: historyKey)
        }
    }
    
    private func loadHistory() {
        if let data = userDefaults.data(forKey: historyKey),
           let recipes = try? JSONDecoder().decode([Recipe].self, from: data) {
            recipeHistory = recipes.sorted { ($0.date ?? Date.distantPast) > ($1.date ?? Date.distantPast) }
        }
    }
    
    func getRecipes(for category: RecipeCategory) -> [Recipe] {
        return allRecipes.filter { $0.category == category }
    }
    
    func getCategoriesWithCounts() -> [(category: RecipeCategory, count: Int)] {
        return RecipeCategory.allCases.map { category in
            let count = allRecipes.filter { $0.category == category }.count
            return (category: category, count: count)
        }.filter { $0.count > 0 }
    }
    
    func getAllRecipesWithDates() -> [Recipe] {
        return allRecipes.sorted { (lhs, rhs) in
            let lhsDate = lhs.date ?? Date.distantPast
            let rhsDate = rhs.date ?? Date.distantPast
            return lhsDate > rhsDate
        }
    }
    
    func getRecipe(by id: UUID) -> Recipe? {
        return allRecipes.first { $0.id == id }
    }
    
    func getCheckedIngredients(for recipeId: UUID) -> Set<UUID> {
        return checkedIngredients[recipeId] ?? []
    }
    
    func toggleIngredient(_ ingredientId: UUID, for recipeId: UUID) {
        if checkedIngredients[recipeId] == nil {
            checkedIngredients[recipeId] = []
        }
        
        if checkedIngredients[recipeId]?.contains(ingredientId) == true {
            checkedIngredients[recipeId]?.remove(ingredientId)
        } else {
            checkedIngredients[recipeId]?.insert(ingredientId)
        }
        
        saveCheckedIngredients()
    }
    
    private func loadCheckedIngredients() {
        if let data = userDefaults.data(forKey: checkedIngredientsKey),
           let decoded = try? JSONDecoder().decode([String: [String]].self, from: data) {
            checkedIngredients = decoded.reduce(into: [UUID: Set<UUID>]()) { result, pair in
                if let recipeId = UUID(uuidString: pair.key) {
                    let ingredientIds = pair.value.compactMap { UUID(uuidString: $0) }
                    result[recipeId] = Set(ingredientIds)
                }
            }
        }
    }
    
    private func saveCheckedIngredients() {
        let encoded = checkedIngredients.reduce(into: [String: [String]]()) { result, pair in
            result[pair.key.uuidString] = Array(pair.value.map { $0.uuidString })
        }
        
        if let data = try? JSONEncoder().encode(encoded) {
            userDefaults.set(data, forKey: checkedIngredientsKey)
        }
    }
    
    private func showToast(message: String) {
        toastMessage = message
        showToast = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showToast = false
        }
    }
}

class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
    @Published var showOnboarding = true
    
    private let hasSeenOnboardingKey = "HasSeenOnboarding"
    
    init() {
        showOnboarding = !UserDefaults.standard.bool(forKey: hasSeenOnboardingKey)
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: hasSeenOnboardingKey)
        showOnboarding = false
    }
    
    func nextPage() {
        currentPage += 1
    }
    
    func previousPage() {
        if currentPage > 0 {
            currentPage -= 1
        }
    }
}

class SettingsViewModel: ObservableObject {
    @Published var showRateApp = false
    
    func openTermsAndConditions() {
        if let url = URL(string: "https://www.termsfeed.com/live/b546b60e-8fd7-490f-8531-36c4a6238034") {
            UIApplication.shared.open(url)
        }
    }
    
    func openPrivacyPolicy() {
        if let url = URL(string: "https://www.termsfeed.com/live/1bf687a9-20a4-43d5-a39e-8fdc9a4b60ba") {
            UIApplication.shared.open(url)
        }
    }
    
    func contactSupport() {
        if let url = URL(string: "https://www.termsfeed.com/live/1bf687a9-20a4-43d5-a39e-8fdc9a4b60ba") {
            UIApplication.shared.open(url)
        }
    }
    
    func rateApp() {
        showRateApp = true
    }
}
