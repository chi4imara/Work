import Foundation
import Combine

struct WeeklyPlanEntry: Codable {
    let date: Date
    let recipeId: UUID
}

class AppState: ObservableObject {
    private enum StorageKey {
        static let hasCompletedOnboarding = "Pantrix.hasCompletedOnboarding"
        static let recipes = "Pantrix.recipes"
        static let availableIngredients = "Pantrix.availableIngredients"
        static let weeklyPlan = "Pantrix.weeklyPlan"
        static let cookedRecipes = "Pantrix.cookedRecipes"
    }
    
    private let userDefaults = UserDefaults.standard
    private let calendar = Calendar.current
    
    @Published var hasCompletedOnboarding: Bool = false
    @Published var currentTab: Tab = .today
    @Published var recipes: [Recipe] = []
    @Published var availableIngredients: [String] = []
    @Published var weeklyPlan: [Date: Recipe] = [:]
    @Published var cookedRecipes: [CookedRecipe] = []
    
    enum Tab: String, CaseIterable {
        case today = "Today"
        case recipes = "My Recipes"
        case history = "History"
        case statistics = "Statistics"
        case settings = "Settings"
        
        var systemImage: String {
            switch self {
            case .today: return "house"
            case .recipes: return "book"
            case .history: return "calendar"
            case .statistics: return "chart.bar"
            case .settings: return "gear"
            }
        }
    }
    
    func recipe(by id: UUID) -> Recipe? {
        recipes.first { $0.id == id }
    }
    
    init() {
        loadData()
    }
    
    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
        saveData()
    }
    
    func updateRecipe(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index] = recipe
            saveData()
        }
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        recipes.removeAll { $0.id == recipe.id }
        saveData()
    }
    
    func toggleFavorite(for recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index].isFavorite.toggle()
            saveData()
        }
    }
    
    func markAsCooked(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index].isCooked = true
            recipes[index].dateCooked = Date()
            
            let cookedRecipe = CookedRecipe(
                recipeId: recipe.id,
                recipeName: recipe.name,
                dateCook: Date()
            )
            cookedRecipes.append(cookedRecipe)
            saveData()
        }
    }
    
    func unmarkAsCooked(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index].isCooked = false
            recipes[index].dateCooked = nil
            cookedRecipes.removeAll { $0.recipeId == recipe.id }
            saveData()
        }
    }
    
    var favoriteRecipes: [Recipe] {
        recipes.filter { $0.isFavorite }
    }
    
    var todayRecommendations: [Recipe] {
        Array(recipes.shuffled().prefix(5))
    }
    
    func recipesWithAvailableIngredients() -> [Recipe] {
        guard !availableIngredients.isEmpty else { return recipes }
        
        return recipes.filter { recipe in
            recipe.ingredients.contains { ingredient in
                availableIngredients.contains { available in
                    ingredient.lowercased().contains(available.lowercased())
                }
            }
        }
    }
    
    func setRecipeForDate(_ recipe: Recipe, date: Date) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        weeklyPlan[startOfDay] = recipe
        saveData()
    }
    
    func recipeForDate(_ date: Date) -> Recipe? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        return weeklyPlan[startOfDay]
    }
    
    func clearRecipeForDate(_ date: Date) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        weeklyPlan.removeValue(forKey: startOfDay)
        saveData()
    }
    
    func addIngredient(_ ingredient: String) {
        if !availableIngredients.contains(ingredient) {
            availableIngredients.append(ingredient)
            saveData()
        }
    }
    
    func removeIngredient(_ ingredient: String) {
        availableIngredients.removeAll { $0 == ingredient }
        saveData()
    }
    
    func markOnboardingCompleted() {
        hasCompletedOnboarding = true
        saveData()
    }
    
    func loadSampleData() {
        recipes = SampleData.recipes
        availableIngredients = SampleData.sampleIngredients
        cookedRecipes = []
        
        let calendar = Calendar.current
        let now = Date()
        
        for (index, recipe) in recipes.enumerated() where index < 4 {
            let daysAgo = index
            guard let date = calendar.date(byAdding: .day, value: -daysAgo, to: now) else { continue }
            cookedRecipes.append(CookedRecipe(
                recipeId: recipe.id,
                recipeName: recipe.name,
                dateCook: date
            ))
        }
        
        if recipes.count > 0 {
            recipes[0].isFavorite = true
        }
        if recipes.count > 2 {
            recipes[2].isFavorite = true
        }
        
        weeklyPlan = [:]
        for dayOffset in 0..<min(4, recipes.count) {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: now) else { continue }
            let startOfDay = calendar.startOfDay(for: date)
            weeklyPlan[startOfDay] = recipes[dayOffset]
        }
        
        saveData()
    }
    
    private func saveData() {
        userDefaults.set(hasCompletedOnboarding, forKey: StorageKey.hasCompletedOnboarding)
        userDefaults.set(availableIngredients, forKey: StorageKey.availableIngredients)
        
        if let recipesData = try? JSONEncoder().encode(recipes) {
            userDefaults.set(recipesData, forKey: StorageKey.recipes)
        }
        
        let weeklyPlanEntries = weeklyPlan.map { startOfDay, recipe in
            WeeklyPlanEntry(date: startOfDay, recipeId: recipe.id)
        }
        if let weeklyData = try? JSONEncoder().encode(weeklyPlanEntries) {
            userDefaults.set(weeklyData, forKey: StorageKey.weeklyPlan)
        }
        
        if let cookedData = try? JSONEncoder().encode(cookedRecipes) {
            userDefaults.set(cookedData, forKey: StorageKey.cookedRecipes)
        }
    }
    
    private func loadData() {
        hasCompletedOnboarding = userDefaults.bool(forKey: StorageKey.hasCompletedOnboarding)
        
        if let ingredients = userDefaults.array(forKey: StorageKey.availableIngredients) as? [String] {
            availableIngredients = ingredients
        }
        
        if let recipesData = userDefaults.data(forKey: StorageKey.recipes),
           let decoded = try? JSONDecoder().decode([Recipe].self, from: recipesData) {
            recipes = decoded
        } else {
            recipes = []
        }
        
        if let cookedData = userDefaults.data(forKey: StorageKey.cookedRecipes),
           let decoded = try? JSONDecoder().decode([CookedRecipe].self, from: cookedData) {
            cookedRecipes = decoded
        } else {
            cookedRecipes = []
        }
        
        if let weeklyData = userDefaults.data(forKey: StorageKey.weeklyPlan),
           let entries = try? JSONDecoder().decode([WeeklyPlanEntry].self, from: weeklyData) {
            weeklyPlan = [:]
            let recipeById = Dictionary(uniqueKeysWithValues: recipes.map { ($0.id, $0) })
            for entry in entries {
                let startOfDay = calendar.startOfDay(for: entry.date)
                if let recipe = recipeById[entry.recipeId] {
                    weeklyPlan[startOfDay] = recipe
                }
            }
        } else {
            weeklyPlan = [:]
        }
    }
}

struct CookedRecipe: Identifiable, Codable {
    let id = UUID()
    let recipeId: UUID
    let recipeName: String
    let dateCook: Date
}
