import Foundation
import SwiftUI

struct Recipe: Identifiable, Codable {
    let id = UUID()
    let name: String
    let cookingTime: Int 
    let difficulty: Difficulty
    let calories: Int
    let category: MealCategory
    let ingredients: [Ingredient]
    let instructions: [String]
    let macros: Macros
    let tags: [String]
    var isLiked: Bool = false
    var isInWishlist: Bool = false
    
    enum Difficulty: String, CaseIterable, Codable {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
    }
    
    enum MealCategory: String, CaseIterable, Codable {
        case breakfast = "Breakfast"
        case lunch = "Lunch"
        case dinner = "Dinner"
        case snack = "Snack"
    }
}

struct Ingredient: Identifiable, Codable {
    let id = UUID()
    let name: String
    let amount: String
    let unit: String
}

struct Macros: Codable {
    let protein: Double
    let carbs: Double
    let fat: Double
    let fiber: Double
}

struct User: Codable {
    var name: String
    var email: String
    var goals: [NutritionGoal]
    var allergies: [String]
    var favoriteIngredients: [String]
    var dietaryPreferences: [DietaryPreference]
    var notificationSettings: NotificationSettings
    
    enum NutritionGoal: String, CaseIterable, Codable {
        case weightLoss = "Weight Loss"
        case healthyEating = "Healthy Eating"
        case muscleGain = "Muscle Gain"
        case maintenance = "Maintenance"
    }
    
    enum DietaryPreference: String, CaseIterable, Codable {
        case vegetarian = "Vegetarian"
        case vegan = "Vegan"
        case glutenFree = "Gluten Free"
        case lowCarb = "Low Carb"
        case keto = "Keto"
        case paleo = "Paleo"
    }
}

struct NotificationSettings: Codable {
    var newRecipes: Bool = true
    var mealReminders: Bool = true
    var nutritionTips: Bool = true
}

struct MealPlan: Identifiable, Codable {
    let id = UUID()
    let date: Date
    var meals: [PlannedMeal]
    
    var totalCalories: Int {
        meals.reduce(0) { $0 + $1.recipe.calories }
    }
    
    var totalMacros: Macros {
        let totalProtein = meals.reduce(0.0) { $0 + $1.recipe.macros.protein }
        let totalCarbs = meals.reduce(0.0) { $0 + $1.recipe.macros.carbs }
        let totalFat = meals.reduce(0.0) { $0 + $1.recipe.macros.fat }
        let totalFiber = meals.reduce(0.0) { $0 + $1.recipe.macros.fiber }
        
        return Macros(protein: totalProtein, carbs: totalCarbs, fat: totalFat, fiber: totalFiber)
    }
}

struct PlannedMeal: Identifiable, Codable {
    let id = UUID()
    let recipe: Recipe
    let category: Recipe.MealCategory
    var status: MealStatus = .planned
    var notes: String = ""
    
    enum MealStatus: String, CaseIterable, Codable {
        case planned = "Planned"
        case cooked = "Cooked"
        case skipped = "Skipped"
    }
}

struct NutritionProgress: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let calories: Int
    let macros: Macros
    let energyLevel: Int
    let mood: Int
    let satietyLevel: Int
}

struct Achievement: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let dateEarned: Date
    let category: AchievementCategory
    
    enum AchievementCategory: String, CaseIterable, Codable {
        case consistency = "Consistency"
        case exploration = "Exploration"
        case health = "Health"
        case cooking = "Cooking"
    }
}

struct RecipeFilters {
    var goals: Set<User.NutritionGoal> = []
    var mealTypes: Set<Recipe.MealCategory> = []
    var excludedIngredients: Set<String> = []
    var difficulty: Recipe.Difficulty?
    var maxCookingTime: Int?
    var dietaryPreferences: Set<User.DietaryPreference> = []
    var maxCalories: Int?
    var minCalories: Int?
    
    var isActive: Bool {
        return !goals.isEmpty || !mealTypes.isEmpty || !excludedIngredients.isEmpty ||
               difficulty != nil || maxCookingTime != nil || !dietaryPreferences.isEmpty ||
               maxCalories != nil || minCalories != nil
    }
    
    mutating func reset() {
        goals.removeAll()
        mealTypes.removeAll()
        excludedIngredients.removeAll()
        difficulty = nil
        maxCookingTime = nil
        dietaryPreferences.removeAll()
        maxCalories = nil
        minCalories = nil
    }
}
