import SwiftUI

struct UserProfile: Codable {
    var name: String
    var email: String
    var goals: [String]
    var dietType: DietType
    var notifications: Bool
    
    init(name: String = "", email: String = "", goals: [String] = [], dietType: DietType = .balanced, notifications: Bool = true) {
        self.name = name
        self.email = email
        self.goals = goals
        self.dietType = dietType
        self.notifications = notifications
    }
}

enum DietType: String, CaseIterable, Codable {
    case balanced = "Balanced"
    case vegan = "Vegan"
    case vegetarian = "Vegetarian"
    case glutenFree = "Gluten Free"
    case keto = "Keto"
    case lowCarb = "Low Carb"
    
    var displayName: String {
        return self.rawValue
    }
}

enum MoodType: String, CaseIterable, Codable {
    case happy = "Happy"
    case energetic = "Energetic"
    case calm = "Calm"
    case stressed = "Stressed"
    case tired = "Tired"
    case focused = "Focused"
    
    var color: Color {
        switch self {
        case .happy: return ColorTheme.primaryYellow
        case .energetic: return ColorTheme.accentOrange
        case .calm: return ColorTheme.primaryBlue
        case .stressed: return ColorTheme.accentPurple
        case .tired: return ColorTheme.backgroundGradientEnd
        case .focused: return ColorTheme.accentGreen
        }
    }
    
    var icon: String {
        switch self {
        case .happy: return "face.smiling"
        case .energetic: return "bolt.fill"
        case .calm: return "leaf.fill"
        case .stressed: return "exclamationmark.triangle.fill"
        case .tired: return "moon.fill"
        case .focused: return "target"
        }
    }
}

enum EnergyLevel: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var color: Color {
        switch self {
        case .low: return ColorTheme.backgroundGradientEnd
        case .medium: return ColorTheme.accentOrange
        case .high: return ColorTheme.accentGreen
        }
    }
}

struct Recipe: Identifiable, Codable {
    let id = UUID()
    var name: String
    var calories: Int
    var energyLevel: EnergyLevel
    var mood: MoodType
    var cookingTime: Int
    var category: String
    var isSaved: Bool = false
    
    static let sampleRecipes: [Recipe] = [
        Recipe(name: "Energizing Smoothie Bowl", calories: 320, energyLevel: .high, mood: .energetic, cookingTime: 10, category: "Breakfast"),
        Recipe(name: "Calming Chamomile Tea", calories: 5, energyLevel: .low, mood: .calm, cookingTime: 5, category: "Beverage"),
        Recipe(name: "Focus Boost Salad", calories: 280, energyLevel: .medium, mood: .focused, cookingTime: 15, category: "Lunch"),
        Recipe(name: "Comfort Pasta", calories: 450, energyLevel: .medium, mood: .happy, cookingTime: 25, category: "Dinner"),
        Recipe(name: "Stress Relief Soup", calories: 180, energyLevel: .low, mood: .calm, cookingTime: 30, category: "Dinner"),
        Recipe(name: "Power Protein Bowl", calories: 380, energyLevel: .high, mood: .energetic, cookingTime: 20, category: "Lunch")
    ]
}

struct MealPlanEntry: Identifiable, Codable {
    let id: UUID
    var recipe: Recipe
    var mealTime: MealTime
    var date: Date
    
    init(recipe: Recipe, mealTime: MealTime, date: Date = Date()) {
        self.id = UUID()
        self.recipe = recipe
        self.mealTime = mealTime
        self.date = date
    }
}

enum MealTime: String, CaseIterable, Codable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
    
    var icon: String {
        switch self {
        case .breakfast: return "sunrise.fill"
        case .lunch: return "sun.max.fill"
        case .dinner: return "sunset.fill"
        case .snack: return "star.fill"
        }
    }
}

struct EnergyEntry: Identifiable, Codable {
    let id: UUID
    var energyLevel: Int
    var mood: MoodType
    var note: String
    var timestamp: Date
    
    init(energyLevel: Int, mood: MoodType, note: String = "", timestamp: Date = Date()) {
        self.id = UUID()
        self.energyLevel = energyLevel
        self.mood = mood
        self.note = note
        self.timestamp = timestamp
    }
}
