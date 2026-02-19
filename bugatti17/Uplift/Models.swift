import Foundation
import SwiftUI

struct Habit: Identifiable, Codable {
    var id: UUID
    var title: String
    var category: String
    var icon: String
    var frequency: HabitFrequency
    var note: String
    var createdDate: Date
    var completedDates: [Date]
    var isCompleted: Bool {
        Calendar.current.isDate(completedDates.last ?? Date.distantPast, inSameDayAs: Date())
    }
    var currentStreak: Int {
        var streak = 0
        let calendar = Calendar.current
        var currentDate = Date()
        
        while completedDates.contains(where: { calendar.isDate($0, inSameDayAs: currentDate) }) {
            streak += 1
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
        }
        
        return streak
    }
    
    init(title: String, category: String, icon: String, frequency: HabitFrequency, note: String = "") {
        self.id = UUID()
        self.title = title
        self.category = category
        self.icon = icon
        self.frequency = frequency
        self.note = note
        self.createdDate = Date()
        self.completedDates = []
    }
    
    init(id: UUID, title: String, category: String, icon: String, frequency: HabitFrequency, note: String, createdDate: Date, completedDates: [Date]) {
        self.id = id
        self.title = title
        self.category = category
        self.icon = icon
        self.frequency = frequency
        self.note = note
        self.createdDate = createdDate
        self.completedDates = completedDates
    }
}

enum HabitFrequency: String, CaseIterable, Codable {
    case once = "Once"
    case daily = "Daily"
    case weekly = "Weekly"
    
    var displayName: String {
        return self.rawValue
    }
}

struct MiniChallenge: Identifiable, Codable {
    var id: UUID
    var title: String
    var description: String
    var category: String
    var isCompleted: Bool = false
    var completedDate: Date?
    
    init(id: UUID = UUID(), title: String, description: String, category: String) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
    }
}

struct DailyEntry: Identifiable, Codable {
    var id: UUID
    let date: Date
    var selectedMoods: [String]
    var completedHabits: [UUID]
    var completedChallenges: [UUID]
    var dailyQuestionAnswer: String
    var dailyQuestion: String
    
    init(date: Date = Date()) {
        self.id = UUID()
        self.date = date
        self.selectedMoods = []
        self.completedHabits = []
        self.completedChallenges = []
        self.dailyQuestionAnswer = ""
        self.dailyQuestion = ""
    }
}

struct UserProgress: Codable {
    var totalHabitsCompleted: Int = 0
    var totalChallengesCompleted: Int = 0
    var longestStreak: Int = 0
    var currentStreak: Int = 0
    var level: Int = 1
    var experience: Int = 0
    
    var experienceToNextLevel: Int {
        return level * 100
    }
    
    var progressToNextLevel: Double {
        return Double(experience) / Double(experienceToNextLevel)
    }
    
    mutating func addExperience(_ points: Int) {
        experience += points
        while experience >= experienceToNextLevel {
            experience -= experienceToNextLevel
            level += 1
        }
    }
}

struct AppState: Codable {
    var hasCompletedOnboarding: Bool = false
    var selectedTab: TabItem = .today
    var habits: [Habit] = []
    var miniChallenges: [MiniChallenge] = []
    var dailyEntries: [DailyEntry] = []
    var userProgress: UserProgress = UserProgress()
    
    var todayEntry: DailyEntry {
        let today = Calendar.current.startOfDay(for: Date())
        return dailyEntries.first { Calendar.current.isDate($0.date, inSameDayAs: today) } ?? DailyEntry(date: today)
    }
}

enum TabItem: String, CaseIterable, Codable {
    case today = "Today"
    case habits = "My Habits"
    case history = "History"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .today:
            return "sun.max.fill"
        case .habits:
            return "checkmark.circle.fill"
        case .history:
            return "calendar"
        case .statistics:
            return "chart.bar.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
}

enum OnboardingState {
    case notStarted
    case inProgress(currentPage: Int)
    case completed
}

struct MoodEntry: Identifiable, Codable {
    var id = UUID()
    let date: Date
    let moods: [String]
    
    init(moods: [String], date: Date = Date()) {
        self.id = UUID()
        self.moods = moods
        self.date = date
    }
}

enum SettingsOption: String, CaseIterable {
    case privacyPolicy = "Privacy Policy"
    case contactEmail = "Contact Us"
    case rateApp = "Rate App"
    
    var icon: String {
        switch self {
        case .privacyPolicy:
            return "shield.fill"
        case .contactEmail:
            return "envelope.fill"
        case .rateApp:
            return "star.fill"
        }
    }
    
    var url: String {
        return "https://www.privacypolicies.com/live/00ad24ce-9ee1-48e1-a340-ca68a488db85"
    }
}
