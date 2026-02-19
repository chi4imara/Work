import Foundation
import SwiftUI
import Combine

private enum UserDefaultsKeys {
    static let recipes = "app_recipes"
    static let mealPlans = "app_mealPlans"
    static let user = "app_user"
}

private let udEncoder: JSONEncoder = {
    let e = JSONEncoder()
    e.dateEncodingStrategy = .iso8601
    return e
}()

private let udDecoder: JSONDecoder = {
    let d = JSONDecoder()
    d.dateDecodingStrategy = .iso8601
    return d
}()

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var filteredRecipes: [Recipe] = []
    @Published var filters = RecipeFilters()
    @Published var isLoading = false
    @Published var searchText = ""
    
    init() {
        loadRecipes()
        applyFilters()
    }
    
    private func loadRecipes() {
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.recipes),
              let decoded = try? udDecoder.decode([Recipe].self, from: data) else { return }
        recipes = decoded
    }
    
    private func saveRecipes() {
        guard let data = try? udEncoder.encode(recipes) else { return }
        UserDefaults.standard.set(data, forKey: UserDefaultsKeys.recipes)
    }
    
    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
        applyFilters()
        saveRecipes()
    }
    
    func updateRecipe(_ recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index] = recipe
            applyFilters()
            saveRecipes()
        }
    }
    
    func recipe(byId id: UUID) -> Recipe? {
        recipes.first { $0.id == id }
    }
    
    func applyFilters() {
        filteredRecipes = recipes.filter { recipe in
            if !filters.goals.isEmpty {
                let meetsGoals = filters.goals.contains { goal in
                    switch goal {
                    case .weightLoss:
                        return recipe.calories < 350
                    case .muscleGain:
                        return recipe.macros.protein > 20
                    case .healthyEating:
                        return recipe.macros.fiber > 3
                    case .maintenance:
                        return true
                    }
                }
                if !meetsGoals { return false }
            }
            
            if !filters.mealTypes.isEmpty && !filters.mealTypes.contains(recipe.category) {
                return false
            }
            
            if let difficulty = filters.difficulty, recipe.difficulty != difficulty {
                return false
            }
            
            if let maxTime = filters.maxCookingTime, recipe.cookingTime > maxTime {
                return false
            }
            
            if let maxCalories = filters.maxCalories, recipe.calories > maxCalories {
                return false
            }
            
            if let minCalories = filters.minCalories, recipe.calories < minCalories {
                return false
            }
            
            if !searchText.isEmpty {
                return recipe.name.localizedCaseInsensitiveContains(searchText) ||
                       recipe.ingredients.contains { $0.name.localizedCaseInsensitiveContains(searchText) }
            }
            
            return true
        }
    }
    
    func refreshRecipes() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.applyFilters()
            self.isLoading = false
        }
    }
    
    func toggleLike(for recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index].isLiked.toggle()
            applyFilters()
            saveRecipes()
        }
    }
    
    func toggleWishlist(for recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index].isInWishlist.toggle()
            applyFilters()
            saveRecipes()
        }
    }
    
    func loadSampleData() {
        recipes = SampleData.sampleRecipes
        applyFilters()
        saveRecipes()
    }
}

class MealPlanViewModel: ObservableObject {
    @Published var mealPlans: [MealPlan] = []
    @Published var selectedDate = Date()
    
    init() {
        loadMealPlans()
    }
    
    private func loadMealPlans() {
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.mealPlans),
              let decoded = try? udDecoder.decode([MealPlan].self, from: data) else { return }
        mealPlans = decoded
    }
    
    private func saveMealPlans() {
        guard let data = try? udEncoder.encode(mealPlans) else { return }
        UserDefaults.standard.set(data, forKey: UserDefaultsKeys.mealPlans)
    }
    
    var currentMealPlan: MealPlan {
        getOrCreatePlanFor(selectedDate)
    }
    
    func getOrCreatePlanFor(_ date: Date) -> MealPlan {
        let calendar = Calendar.current
        if let existing = mealPlans.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            return existing
        }
        let newPlan = MealPlan(date: date, meals: [])
        mealPlans.append(newPlan)
        saveMealPlans()
        return newPlan
    }
    
    func meal(byId id: UUID) -> PlannedMeal? {
        for plan in mealPlans {
            if let meal = plan.meals.first(where: { $0.id == id }) {
                return meal
            }
        }
        return nil
    }
    
    func updateMeal(_ updatedMeal: PlannedMeal) {
        for planIndex in mealPlans.indices {
            if let mealIndex = mealPlans[planIndex].meals.firstIndex(where: { $0.id == updatedMeal.id }) {
                var planCopy = mealPlans[planIndex]
                planCopy.meals[mealIndex] = updatedMeal
                mealPlans[planIndex] = planCopy
                saveMealPlans()
                return
            }
        }
    }
    
    func addMeal(_ recipe: Recipe, category: Recipe.MealCategory, date: Date = Date()) {
        let plannedMeal = PlannedMeal(recipe: recipe, category: category)
        let plan = getOrCreatePlanFor(date)
        if let planIndex = mealPlans.firstIndex(where: { $0.id == plan.id }) {
            var planCopy = mealPlans[planIndex]
            planCopy.meals.append(plannedMeal)
            mealPlans[planIndex] = planCopy
            saveMealPlans()
        }
    }
    
    func updateMealStatus(_ mealId: UUID, status: PlannedMeal.MealStatus) {
        for planIndex in mealPlans.indices {
            if let mealIndex = mealPlans[planIndex].meals.firstIndex(where: { $0.id == mealId }) {
                var planCopy = mealPlans[planIndex]
                var mealCopy = planCopy.meals[mealIndex]
                mealCopy.status = status
                planCopy.meals[mealIndex] = mealCopy
                mealPlans[planIndex] = planCopy
                saveMealPlans()
                return
            }
        }
    }
    
    func removeMeal(_ mealId: UUID) {
        for planIndex in mealPlans.indices {
            var planCopy = mealPlans[planIndex]
            planCopy.meals.removeAll { $0.id == mealId }
            mealPlans[planIndex] = planCopy
        }
        saveMealPlans()
    }
    
    func loadSampleData(recipes: [Recipe]) {
        mealPlans = SampleData.sampleMealPlans(using: recipes)
        saveMealPlans()
    }
}

class ProgressViewModel: ObservableObject {
    @Published var nutritionProgress: [NutritionProgress] = []
    @Published var achievements: [Achievement] = []
    @Published var selectedTimeRange: TimeRange = .week
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
    
    init() {}
    
    func addProgress(_ progress: NutritionProgress) {
        nutritionProgress.append(progress)
    }
    
    func addAchievement(_ achievement: Achievement) {
        achievements.append(achievement)
    }
    
    var filteredProgress: [NutritionProgress] {
        let calendar = Calendar.current
        let today = Date()
        
        switch selectedTimeRange {
        case .week:
            return nutritionProgress.filter { progress in
                calendar.dateInterval(of: .weekOfYear, for: today)?.contains(progress.date) ?? false
            }
        case .month:
            return nutritionProgress.filter { progress in
                calendar.dateInterval(of: .month, for: today)?.contains(progress.date) ?? false
            }
        case .year:
            return nutritionProgress.filter { progress in
                calendar.dateInterval(of: .year, for: today)?.contains(progress.date) ?? false
            }
        }
    }
    
    var averageCalories: Int {
        let filtered = filteredProgress
        guard !filtered.isEmpty else { return 0 }
        return filtered.reduce(0) { $0 + $1.calories } / filtered.count
    }
    
    var averageMacros: Macros {
        let filtered = filteredProgress
        guard !filtered.isEmpty else { return Macros(protein: 0, carbs: 0, fat: 0, fiber: 0) }
        
        let totalProtein = filtered.reduce(0.0) { $0 + $1.macros.protein }
        let totalCarbs = filtered.reduce(0.0) { $0 + $1.macros.carbs }
        let totalFat = filtered.reduce(0.0) { $0 + $1.macros.fat }
        let totalFiber = filtered.reduce(0.0) { $0 + $1.macros.fiber }
        
        let count = Double(filtered.count)
        return Macros(
            protein: totalProtein / count,
            carbs: totalCarbs / count,
            fat: totalFat / count,
            fiber: totalFiber / count
        )
    }
}

class UserViewModel: ObservableObject {
    @Published var user = User(
        name: "",
        email: "",
        goals: [],
        allergies: [],
        favoriteIngredients: [],
        dietaryPreferences: [],
        notificationSettings: NotificationSettings()
    )
    
    init() {
        loadUser()
    }
    
    private func loadUser() {
        guard let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.user),
              let decoded = try? udDecoder.decode(User.self, from: data) else { return }
        user = decoded
    }
    
    private func saveUser() {
        guard let data = try? udEncoder.encode(user) else { return }
        UserDefaults.standard.set(data, forKey: UserDefaultsKeys.user)
    }
    
    func persistUser() {
        saveUser()
    }
    
    func updateUser(_ updatedUser: User) {
        user = updatedUser
        saveUser()
    }
    
    func addGoal(_ goal: User.NutritionGoal) {
        if !user.goals.contains(goal) {
            user.goals.append(goal)
            saveUser()
        }
    }
    
    func removeGoal(_ goal: User.NutritionGoal) {
        user.goals.removeAll { $0 == goal }
        saveUser()
    }
    
    func addAllergy(_ allergy: String) {
        if !user.allergies.contains(allergy) {
            user.allergies.append(allergy)
            saveUser()
        }
    }
    
    func removeAllergy(_ allergy: String) {
        user.allergies.removeAll { $0 == allergy }
        saveUser()
    }
    
    func loadSampleData() {
        user = SampleData.sampleUser
        saveUser()
    }
}
