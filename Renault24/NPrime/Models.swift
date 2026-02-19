import Foundation

struct Workout: Identifiable, Codable {
    let id = UUID()
    var name: String
    var category: WorkoutCategory
    var duration: Int 
    var exercises: [Exercise]
    var isCompleted: Bool = false
    var date: Date = Date()
    var isFavorite: Bool = false
    var notes: String = ""
}

enum WorkoutCategory: String, CaseIterable, Codable {
    case strength = "Strength"
    case cardio = "Cardio"
    case functional = "Functional"
    
    var icon: String {
        switch self {
        case .strength: return "dumbbell"
        case .cardio: return "heart.fill"
        case .functional: return "figure.strengthtraining.functional"
        }
    }
}

struct Exercise: Identifiable, Codable {
    let id = UUID()
    var name: String
    var sets: Int
    var reps: Int
    var weight: Double?
    var isCompleted: Bool = false
}

struct Meal: Identifiable, Codable {
    let id = UUID()
    var name: String
    var mealType: MealType
    var calories: Int
    var protein: Double
    var carbs: Double
    var fat: Double
    var isCompleted: Bool = false
    var date: Date = Date()
    var notes: String = ""
}

enum MealType: String, CaseIterable, Codable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
    
    var icon: String {
        switch self {
        case .breakfast: return "sunrise.fill"
        case .lunch: return "sun.max.fill"
        case .dinner: return "moon.fill"
        case .snack: return "leaf.fill"
        }
    }
}

struct Goal: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var targetValue: Double
    var currentValue: Double
    var unit: String
    var category: GoalCategory
    var deadline: Date
    var isCompleted: Bool = false
    var isFavorite: Bool = false
    var notes: String = ""
}

enum GoalCategory: String, CaseIterable, Codable {
    case weightLoss = "Weight Loss"
    case muscleGain = "Muscle Gain"
    case strength = "Strength Increase"
    case endurance = "Endurance"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .weightLoss: return "arrow.down.circle"
        case .muscleGain: return "arrow.up.circle"
        case .strength: return "bolt.fill"
        case .endurance: return "timer"
        case .other: return "target"
        }
    }
}

struct Challenge: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var targetValue: Int
    var currentValue: Int = 0
    var isCompleted: Bool = false
    var date: Date = Date()
    
    var progress: Double {
        guard targetValue > 0 else { return 0 }
        return min(Double(currentValue) / Double(targetValue), 1.0)
    }
}

struct DayProgress: Identifiable, Codable {
    let id = UUID()
    let date: Date
    var workoutsCompleted: Int = 0
    var mealsCompleted: Int = 0
    var goalsProgress: Double = 0
    var challengeCompleted: Bool = false
    
    var overallProgress: Double {
        let workoutScore = workoutsCompleted > 0 ? 0.25 : 0
        let mealScore = mealsCompleted >= 3 ? 0.25 : Double(mealsCompleted) * 0.083
        let goalScore = goalsProgress * 0.25
        let challengeScore = challengeCompleted ? 0.25 : 0
        
        return workoutScore + mealScore + goalScore + challengeScore
    }
}
