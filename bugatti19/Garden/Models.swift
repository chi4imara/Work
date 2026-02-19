import Foundation
import SwiftUI

struct User: Codable {
    let id: UUID
    var name: String
    var joinDate: Date
    
    init(name: String = "User") {
        self.id = UUID()
        self.name = name
        self.joinDate = Date()
    }
}

struct DailyProgress: Codable, Identifiable {
    let id: UUID
    let date: Date
    var sleepEntry: SleepEntry?
    var mealEntries: [MealEntry]
    var activityEntries: [ActivityEntry]
    var completedChallenges: [UUID]
    var moodRating: Int?
    var energyLevel: Int?
    var notes: String
    
    init(date: Date = Date()) {
        self.id = UUID()
        self.date = date
        self.mealEntries = []
        self.activityEntries = []
        self.completedChallenges = []
        self.notes = ""
    }
    
    var completionPercentage: Double {
        var completed = 0
        var total = 4
        
        if sleepEntry != nil { completed += 1 }
        if !mealEntries.isEmpty { completed += 1 }
        if !activityEntries.isEmpty { completed += 1 }
        if !completedChallenges.isEmpty { completed += 1 }
        
        return Double(completed) / Double(total)
    }
}

struct SleepEntry: Codable, Identifiable {
    let id: UUID
    let bedtime: Date
    let wakeTime: Date
    var quality: Int
    
    init(bedtime: Date, wakeTime: Date, quality: Int = 3) {
        self.id = UUID()
        self.bedtime = bedtime
        self.wakeTime = wakeTime
        self.quality = quality
    }
    
    var duration: TimeInterval {
        wakeTime.timeIntervalSince(bedtime)
    }
    
    var durationHours: Double {
        duration / 3600
    }
}

struct MealEntry: Codable, Identifiable {
    let id: UUID
    let type: MealType
    let name: String
    let timestamp: Date
    var healthRating: Int
    var notes: String
    
    init(type: MealType, name: String, healthRating: Int = 3) {
        self.id = UUID()
        self.type = type
        self.name = name
        self.timestamp = Date()
        self.healthRating = healthRating
        self.notes = ""
    }
}

enum MealType: String, CaseIterable, Codable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
    
    var icon: String {
        switch self {
        case .breakfast: return "sun.righthalf.filled"
        case .lunch: return "sun.max"
        case .dinner: return "moon"
        case .snack: return "leaf"
        }
    }
}

struct ActivityEntry: Codable, Identifiable {
    let id: UUID
    let type: ActivityType
    let name: String
    let timestamp: Date
    var duration: TimeInterval
    var isCompleted: Bool
    var notes: String
    
    init(type: ActivityType, name: String, duration: TimeInterval = 0) {
        self.id = UUID()
        self.type = type
        self.name = name
        self.timestamp = Date()
        self.duration = duration
        self.isCompleted = false
        self.notes = ""
    }
}

enum ActivityType: String, CaseIterable, Codable {
    case walk = "Walk"
    case yoga = "Yoga"
    case workout = "Workout"
    case meditation = "Meditation"
    case stretching = "Stretching"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .walk: return "figure.walk"
        case .yoga: return "figure.yoga"
        case .workout: return "dumbbell"
        case .meditation: return "brain.head.profile"
        case .stretching: return "figure.flexibility"
        case .other: return "star"
        }
    }
}

struct Habit: Codable, Identifiable {
    let id: UUID
    var name: String
    var category: HabitCategory
    var frequency: HabitFrequency
    var icon: String
    var description: String
    let createdDate: Date
    var completedDates: [Date]
    var isActive: Bool
    
    init(name: String, category: HabitCategory, frequency: HabitFrequency = .daily, icon: String = "star") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.frequency = frequency
        self.icon = icon
        self.description = ""
        self.createdDate = Date()
        self.completedDates = []
        self.isActive = true
    }
    
    init(id: UUID, name: String, category: HabitCategory, frequency: HabitFrequency, icon: String, description: String, createdDate: Date, completedDates: [Date], isActive: Bool) {
        self.id = id
        self.name = name
        self.category = category
        self.frequency = frequency
        self.icon = icon
        self.description = description
        self.createdDate = createdDate
        self.completedDates = completedDates
        self.isActive = isActive
    }
    
    var currentStreak: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var streak = 0
        var currentDate = today
        
        while completedDates.contains(where: { calendar.isDate($0, inSameDayAs: currentDate) }) {
            streak += 1
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
        }
        
        return streak
    }
}

enum HabitCategory: String, CaseIterable, Codable {
    case sleep = "Sleep"
    case nutrition = "Nutrition"
    case activity = "Activity"
    case mindfulness = "Mindfulness"
    case selfCare = "Self Care"
    case hobby = "Hobby"
    
    var color: Color {
        switch self {
        case .sleep: return AppColors.lightPurple
        case .nutrition: return AppColors.lightGreen
        case .activity: return AppColors.primaryYellow
        case .mindfulness: return AppColors.softPink
        case .selfCare: return AppColors.lightBlue
        case .hobby: return AppColors.softYellow
        }
    }
    
    var icon: String {
        switch self {
        case .sleep: return "bed.double"
        case .nutrition: return "leaf"
        case .activity: return "figure.run"
        case .mindfulness: return "brain.head.profile"
        case .selfCare: return "heart"
        case .hobby: return "paintbrush"
        }
    }
}

enum HabitFrequency: String, CaseIterable, Codable {
    case daily = "Daily"
    case weekly = "Weekly"
    case oneTime = "One Time"
}

struct Challenge: Codable, Identifiable {
    let id: UUID
    let title: String
    let description: String
    let category: HabitCategory
    let estimatedDuration: String
    var isCompleted: Bool
    let createdDate: Date
    
    init(title: String, description: String, category: HabitCategory, estimatedDuration: String = "5 min") {
        self.id = UUID()
        self.title = title
        self.description = description
        self.category = category
        self.estimatedDuration = estimatedDuration
        self.isCompleted = false
        self.createdDate = Date()
    }
}

extension Challenge {
    static let sampleChallenges: [Challenge] = [
        Challenge(title: "5 minutes meditation", description: "Take a moment to breathe and center yourself", category: .mindfulness),
        Challenge(title: "Write 1 gratitude", description: "Think of something you're grateful for today", category: .selfCare),
        Challenge(title: "10 minutes stretching", description: "Gentle stretches to energize your body", category: .activity),
        Challenge(title: "Drink a glass of water", description: "Stay hydrated and refreshed", category: .nutrition),
        Challenge(title: "Take 5 deep breaths", description: "Reset your energy with mindful breathing", category: .mindfulness),
    ]
}
