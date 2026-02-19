import Foundation

enum MealType: String, CaseIterable, Identifiable, Codable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
    
    var id: String { self.rawValue }
}

enum MoodGoal: String, CaseIterable, Identifiable, Codable {
    case energy = "Energy"
    case focus = "Focus"
    case relax = "Relax"
    
    var id: String { self.rawValue }
    
    var color: String {
        switch self {
        case .energy: return "orange"
        case .focus: return "green"
        case .relax: return "purple"
        }
    }
}

enum MealStatus: String, CaseIterable, Codable {
    case planned = "Planned"
    case consumed = "Consumed"
    case skipped = "Skipped"
}

struct Food: Identifiable, Codable {
    let id: UUID
    let name: String
    let type: MealType
    let calories: Int
    let goal: MoodGoal
    let description: String
    let ingredients: [String]
    
    init(id: UUID = UUID(), name: String, type: MealType, calories: Int, goal: MoodGoal, description: String, ingredients: [String]) {
        self.id = id
        self.name = name
        self.type = type
        self.calories = calories
        self.goal = goal
        self.description = description
        self.ingredients = ingredients
    }
    
}

struct MealEntry: Identifiable, Codable {
    let id: UUID
    let food: Food
    let date: Date
    var status: MealStatus
    let plannedTime: Date?
    let actualTime: Date?
    
    init(id: UUID = UUID(), food: Food, date: Date = Date(), status: MealStatus = .planned, plannedTime: Date? = nil, actualTime: Date? = nil) {
        self.id = id
        self.food = food
        self.date = date
        self.status = status
        self.plannedTime = plannedTime
        self.actualTime = actualTime
    }
}

struct UserProfile: Codable {
    var name: String
    var email: String
    var allergies: [String]
    var preferences: [String]
    var notificationsEnabled: Bool
    var dailyCalorieGoal: Int
    
    init() {
        self.name = ""
        self.email = ""
        self.allergies = []
        self.preferences = []
        self.notificationsEnabled = true
        self.dailyCalorieGoal = 2000
    }
}

struct EnergyData: Identifiable, Codable, Equatable {
    let id: UUID
    let date: Date
    let energyLevel: Double
    let mood: String

    init(id: UUID = UUID(), date: Date, energyLevel: Double, mood: String) {
        self.id = id
        self.date = date
        self.energyLevel = energyLevel
        self.mood = mood
    }
}

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let isUnlocked: Bool
    let date: Date?
}

struct FilterOptions {
    var selectedGoal: MoodGoal?
    var selectedMealType: MealType?
    var maxCalories: Int?
    var minCalories: Int?
    
    func matches(food: Food) -> Bool {
        if let goal = selectedGoal, food.goal != goal {
            return false
        }
        
        if let mealType = selectedMealType, food.type != mealType {
            return false
        }
        
        if let maxCal = maxCalories, food.calories > maxCal {
            return false
        }
        
        if let minCal = minCalories, food.calories < minCal {
            return false
        }
        
        return true
    }
    
    var isEmpty: Bool {
        selectedGoal == nil && selectedMealType == nil && maxCalories == nil && minCalories == nil
    }
}
