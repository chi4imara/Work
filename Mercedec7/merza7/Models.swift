import Foundation
import SwiftUI

enum HabitType: String, CaseIterable, Identifiable {
    case sleep = "Sleep"
    case activity = "Activity"
    case water = "Water"
    case mindfulness = "Mindfulness"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .sleep: return "moon.fill"
        case .activity: return "figure.walk"
        case .water: return "drop.fill"
        case .mindfulness: return "leaf.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .sleep: return AppColors.lavender
        case .activity: return AppColors.lightGreen
        case .water: return AppColors.primaryBlue
        case .mindfulness: return AppColors.peach
        }
    }
}

enum Frequency: String, CaseIterable, Identifiable {
    case daily = "Daily"
    case weekly = "Weekly"
    case custom = "Custom"
    
    var id: String { rawValue }
}

enum TaskDuration: String, CaseIterable, Identifiable {
    case short = "5-10 min"
    case medium = "15-30 min"
    case long = "30+ min"
    
    var id: String { rawValue }
    
    var minutes: Int {
        switch self {
        case .short: return 10
        case .medium: return 25
        case .long: return 45
        }
    }
}

struct User: Codable, Identifiable, Equatable {
    var id: UUID
    var name: String
    var email: String
    var avatar: String?
    var goals: [String]
    var notificationsEnabled: Bool
    var morningReminderTime: Date?
    var eveningReminderTime: Date?
    var createdAt: Date
    
    init(name: String = "", email: String = "", goals: [HabitType] = [], notificationsEnabled: Bool = true) {
        self.id = UUID()
        self.name = name
        self.email = email
        self.avatar = nil
        self.goals = goals.map { $0.rawValue }
        self.notificationsEnabled = notificationsEnabled
        self.morningReminderTime = Self.makeTime(hour: 8, minute: 0)
        self.eveningReminderTime = Self.makeTime(hour: 19, minute: 0)
        self.createdAt = Date()
    }
    
    static func makeTime(hour: Int, minute: Int) -> Date {
        let calendar = Calendar.current
        let now = Date()
        var comp = calendar.dateComponents([.year, .month, .day], from: now)
        comp.hour = hour
        comp.minute = minute
        comp.second = 0
        return calendar.date(from: comp) ?? calendar.startOfDay(for: now)
    }
    
    var morningTime: Date {
        get { morningReminderTime ?? Self.makeTime(hour: 8, minute: 0) }
        set { morningReminderTime = newValue }
    }
    
    var eveningTime: Date {
        get { eveningReminderTime ?? Self.makeTime(hour: 19, minute: 0) }
        set { eveningReminderTime = newValue }
    }
    
    var goalTypes: [HabitType] {
        get {
            goals.compactMap { HabitType(rawValue: $0) }
        }
        set {
            goals = newValue.map { $0.rawValue }
        }
    }
}

struct Habit: Codable, Identifiable, Equatable {
    var id: UUID
    var name: String
    var typeString: String
    var frequencyString: String
    var targetDays: Int
    var completedDays: Int
    var streak: Int
    var isActive: Bool
    var createdAt: Date
    var lastCompletedDate: Date?
    
    var type: HabitType {
        get { HabitType(rawValue: typeString) ?? .sleep }
        set { typeString = newValue.rawValue }
    }
    
    var frequency: Frequency {
        get { Frequency(rawValue: frequencyString) ?? .daily }
        set { frequencyString = newValue.rawValue }
    }
    
    init(name: String, type: HabitType, frequency: Frequency = .daily, targetDays: Int = 7) {
        self.id = UUID()
        self.name = name
        self.typeString = type.rawValue
        self.frequencyString = frequency.rawValue
        self.targetDays = targetDays
        self.completedDays = 0
        self.streak = 0
        self.isActive = true
        self.createdAt = Date()
        self.lastCompletedDate = nil
    }
    
    var progress: Double {
        guard targetDays > 0 else { return 0 }
        let calculatedProgress = Double(completedDays) / Double(targetDays)
        return max(0, min(1, calculatedProgress))
    }
    
    var progressPercentage: Int {
        Int(progress * 100)
    }
}

struct TaskForBuild: Codable, Identifiable, Equatable {
    var id: UUID
    var title: String
    var description: String
    var typeString: String
    var durationString: String
    var goal: String
    var isCompleted: Bool
    var completedAt: Date?
    var createdAt: Date
    
    var type: HabitType {
        get { HabitType(rawValue: typeString) ?? .sleep }
        set { typeString = newValue.rawValue }
    }
    
    var duration: TaskDuration {
        get { TaskDuration(rawValue: durationString) ?? .short }
        set { durationString = newValue.rawValue }
    }
    
    init(title: String, description: String, type: HabitType, duration: TaskDuration, goal: String) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.typeString = type.rawValue
        self.durationString = duration.rawValue
        self.goal = goal
        self.isCompleted = false
        self.createdAt = Date()
        self.completedAt = nil
    }
    
    mutating func markCompleted() {
        isCompleted = true
        completedAt = Date()
    }
}

struct Achievement: Codable, Identifiable, Equatable {
    var id: UUID
    var title: String
    var description: String
    var typeString: String
    var isUnlocked: Bool
    var unlockedAt: Date?
    var requiredDays: Int
    
    var type: HabitType {
        get { HabitType(rawValue: typeString) ?? .sleep }
        set { typeString = newValue.rawValue }
    }
    
    init(title: String, description: String, type: HabitType, requiredDays: Int) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.typeString = type.rawValue
        self.requiredDays = requiredDays
        self.isUnlocked = false
        self.unlockedAt = nil
    }
    
    mutating func unlock() {
        isUnlocked = true
        unlockedAt = Date()
    }
}

struct ProgressData: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
    let type: HabitType
}

struct TaskFilter {
    var selectedTypes: Set<HabitType> = []
    var selectedDurations: Set<TaskDuration> = []
    var searchText: String = ""
    
    var isActive: Bool {
        !selectedTypes.isEmpty || !selectedDurations.isEmpty || !searchText.isEmpty
    }
    
    mutating func reset() {
        selectedTypes.removeAll()
        selectedDurations.removeAll()
        searchText = ""
    }
}
