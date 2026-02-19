import Foundation

struct Workout: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var category: WorkoutCategory
    var duration: Int 
    var repetitions: Int?
    var notes: String?
    var isCompleted: Bool = false
    var isFavorite: Bool = false
    var createdDate: Date = Date()
    var completedDate: Date?
    
    init(name: String, category: WorkoutCategory, duration: Int, repetitions: Int? = nil, notes: String? = nil) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.duration = duration
        self.repetitions = repetitions
        self.notes = notes
    }
    
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        return lhs.id == rhs.id
    }
}

enum WorkoutCategory: String, CaseIterable, Codable {
    case cardio = "Cardio"
    case strength = "Strength"
    case functional = "Functional"
    case flexibility = "Flexibility"
    
    var icon: String {
        switch self {
        case .cardio: return "heart.fill"
        case .strength: return "dumbbell.fill"
        case .functional: return "figure.strengthtraining.functional"
        case .flexibility: return "figure.yoga"
        }
    }
}

struct Nutrition: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var mealType: MealType
    var calories: Int
    var notes: String?
    var isCompleted: Bool = false
    var isFavorite: Bool = false
    var createdDate: Date = Date()
    var completedDate: Date?
    
    init(name: String, mealType: MealType, calories: Int, notes: String? = nil) {
        self.id = UUID()
        self.name = name
        self.mealType = mealType
        self.calories = calories
        self.notes = notes
    }
    
    static func == (lhs: Nutrition, rhs: Nutrition) -> Bool {
        return lhs.id == rhs.id
    }
}

enum MealType: String, CaseIterable, Codable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
    
    var icon: String {
        switch self {
        case .breakfast: return "sun.max.circle.fill"
        case .lunch: return "sun.max.fill"
        case .dinner: return "moon.fill"
        case .snack: return "leaf.fill"
        }
    }
}

struct ProductivityTask: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var category: TaskCategory
    var priority: TaskPriority
    var notes: String?
    var isCompleted: Bool = false
    var isFavorite: Bool = false
    var createdDate: Date = Date()
    var completedDate: Date?
    
    init(name: String, category: TaskCategory, priority: TaskPriority, notes: String? = nil) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.priority = priority
        self.notes = notes
    }
    
    static func == (lhs: ProductivityTask, rhs: ProductivityTask) -> Bool {
        return lhs.id == rhs.id
    }
}

enum TaskCategory: String, CaseIterable, Codable {
    case work = "Work"
    case study = "Study"
    case personal = "Personal"
    case health = "Health"
    
    var icon: String {
        switch self {
        case .work: return "briefcase.fill"
        case .study: return "book.fill"
        case .personal: return "person.fill"
        case .health: return "heart.fill"
        }
    }
}

enum TaskPriority: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var color: String {
        switch self {
        case .low: return "green"
        case .medium: return "orange"
        case .high: return "red"
        }
    }
}

struct Challenge: Identifiable, Codable {
    let id = UUID()
    var name: String
    var description: String
    var targetValue: Int
    var currentValue: Int = 0
    var unit: String
    var isCompleted: Bool = false
    var createdDate: Date = Date()
    var completedDate: Date?
    
    var progress: Double {
        if isCompleted { return 1.0 }
        guard targetValue > 0 else { return 0 }
        return min(Double(currentValue) / Double(targetValue), 1.0)
    }
}

struct WaterIntake: Codable {
    var currentAmount: Int = 0
    var targetAmount: Int = 2000
    var date: Date = Date()
    
    var progress: Double {
        return min(Double(currentAmount) / Double(targetAmount), 1.0)
    }
}

struct DailyProgress: Identifiable, Codable {
    let id = UUID()
    var date: Date
    var workoutsCompleted: Int = 0
    var nutritionItemsCompleted: Int = 0
    var tasksCompleted: Int = 0
    var challengesCompleted: Int = 0
    var waterIntake: WaterIntake = WaterIntake()
    
    var totalProgress: Double {
        let workoutProgress = workoutsCompleted > 0 ? 0.25 : 0
        let nutritionProgress = nutritionItemsCompleted > 0 ? 0.25 : 0
        let taskProgress = tasksCompleted > 0 ? 0.25 : 0
        let challengeProgress = challengesCompleted > 0 ? 0.25 : 0
        
        return workoutProgress + nutritionProgress + taskProgress + challengeProgress
    }
}

struct AppState: Codable {
    var hasCompletedOnboarding: Bool = false
    var currentStreak: Int = 0
    var totalWorkouts: Int = 0
    var totalTasks: Int = 0
    var totalChallenges: Int = 0
}
