import Foundation

struct UserProfile: Codable {
    var name: String
    var email: String
    var fitnessLevel: FitnessLevel
    var goals: [FitnessGoal]
    var preferredWorkouts: [WorkoutType]
    var avatarImageName: String?
    var avatarPhotoFileName: String?
    var notificationsEnabled: Bool
    
    init() {
        self.name = ""
        self.email = ""
        self.fitnessLevel = .beginner
        self.goals = []
        self.preferredWorkouts = []
        self.avatarImageName = nil
        self.avatarPhotoFileName = nil
        self.notificationsEnabled = true
    }
}

enum FitnessLevel: String, CaseIterable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}

enum FitnessGoal: String, CaseIterable, Codable {
    case weightLoss = "Weight Loss"
    case strength = "Strength"
    case endurance = "Endurance"
    case toning = "Toning"
}

enum WorkoutType: String, CaseIterable, Codable {
    case cardio = "Cardio"
    case strength = "Strength"
    case yoga = "Yoga"
    case pilates = "Pilates"
}

enum WorkoutStatus: String, CaseIterable, Codable {
    case planned = "Planned"
    case completed = "Completed"
    case missed = "Missed"
}

struct Workout: Identifiable, Codable {
    var id: UUID
    var name: String
    var type: WorkoutType
    var duration: Int
    var difficulty: FitnessLevel
    var goal: FitnessGoal
    var imageName: String
    var description: String
    
    init(id: UUID = UUID(), name: String, type: WorkoutType, duration: Int, difficulty: FitnessLevel, goal: FitnessGoal, imageName: String, description: String) {
        self.id = id
        self.name = name
        self.type = type
        self.duration = duration
        self.difficulty = difficulty
        self.goal = goal
        self.imageName = imageName
        self.description = description
    }
}

struct ScheduledWorkout: Identifiable, Codable {
    let id = UUID()
    var workout: Workout
    var scheduledDate: Date
    var status: WorkoutStatus
    var notes: String?
    var completedDate: Date?
    
    init(workout: Workout, scheduledDate: Date, status: WorkoutStatus = .planned) {
        self.workout = workout
        self.scheduledDate = scheduledDate
        self.status = status
        self.notes = nil
        self.completedDate = nil
    }
}

struct Achievement: Identifiable, Codable {
    var id: UUID
    var title: String
    var description: String
    var iconName: String
    var isUnlocked: Bool
    var unlockedDate: Date?
    
    init(id: UUID = UUID(), title: String, description: String, iconName: String, isUnlocked: Bool = false, unlockedDate: Date? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.iconName = iconName
        self.isUnlocked = isUnlocked
        self.unlockedDate = unlockedDate
    }
    
    static func defaultAchievementTemplates() -> [Achievement] {
        [
            Achievement(title: "First Steps", description: "Complete your first workout", iconName: "star.fill"),
            Achievement(title: "Consistency Champion", description: "Complete 5 workouts in a row", iconName: "flame.fill"),
            Achievement(title: "Variety Explorer", description: "Try 3 different workout types", iconName: "sparkles"),
            Achievement(title: "Week Warrior", description: "Complete 7 workouts in one week", iconName: "trophy.fill")
        ]
    }
}

struct ProgressData: Codable {
    var weeklyWorkouts: [Date: Int]
    var monthlyWorkouts: [Date: Int]
    var totalWorkouts: Int
    var currentStreak: Int
    var longestStreak: Int
    var energyLevels: [Date: Int] 
    var achievements: [Achievement]
    
    init() {
        self.weeklyWorkouts = [:]
        self.monthlyWorkouts = [:]
        self.totalWorkouts = 0
        self.currentStreak = 0
        self.longestStreak = 0
        self.energyLevels = [:]
        self.achievements = Achievement.defaultAchievementTemplates()
    }
}
