import Foundation
import SwiftUI

struct Mood: Identifiable, Codable {
    let id: UUID
    let emoji: String
    let name: String
    let date: Date
    
    init(id: UUID = UUID(), emoji: String, name: String, date: Date) {
        self.id = id
        self.emoji = emoji
        self.name = name
        self.date = date
    }
    
    static let allMoods = [
        Mood(emoji: "😊", name: "Happy", date: Date()),
        Mood(emoji: "😌", name: "Calm", date: Date()),
        Mood(emoji: "😴", name: "Tired", date: Date()),
        Mood(emoji: "😔", name: "Sad", date: Date()),
        Mood(emoji: "😰", name: "Anxious", date: Date()),
        Mood(emoji: "😡", name: "Angry", date: Date()),
        Mood(emoji: "🤔", name: "Thoughtful", date: Date())
    ]
}

struct Habit: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: HabitCategory
    var iconName: String
    var frequency: HabitFrequency
    var whyImportant: String
    var createdDate: Date
    var completedDates: [Date]
    var isActive: Bool
    
    init(id: UUID = UUID(), name: String, category: HabitCategory, iconName: String, frequency: HabitFrequency, whyImportant: String, createdDate: Date, completedDates: [Date], isActive: Bool) {
        self.id = id
        self.name = name
        self.category = category
        self.iconName = iconName
        self.frequency = frequency
        self.whyImportant = whyImportant
        self.createdDate = createdDate
        self.completedDates = completedDates
        self.isActive = isActive
    }
    
    var currentStreak: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var streak = 0
        
        for i in 0..<completedDates.count {
            let date = calendar.startOfDay(for: today.addingTimeInterval(-Double(i) * 24 * 60 * 60))
            if completedDates.contains(where: { calendar.isDate($0, inSameDayAs: date) }) {
                streak += 1
            } else {
                break
            }
        }
        return streak
    }
    
    var isCompletedToday: Bool {
        let calendar = Calendar.current
        return completedDates.contains { calendar.isDate($0, inSameDayAs: Date()) }
    }
}

enum HabitCategory: String, CaseIterable, Codable {
    case meditation = "Meditation"
    case breathing = "Breathing"
    case emotionalJournal = "Emotional Journal"
    case selfCare = "Self Care"
    
    var iconName: String {
        switch self {
        case .meditation: return "leaf.fill"
        case .breathing: return "wind"
        case .emotionalJournal: return "book.fill"
        case .selfCare: return "heart.fill"
        }
    }
}

enum HabitFrequency: String, CaseIterable, Codable {
    case once = "Once"
    case daily = "Daily"
    case weekly = "Weekly"
    
    var description: String {
        return self.rawValue
    }
}

struct Challenge: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let category: HabitCategory
    var isCompleted: Bool
    let date: Date
    
    static let dailyChallenges = [
        Challenge(title: "One Gratitude", description: "Write down one thing you're grateful for today", category: .emotionalJournal, isCompleted: false, date: Date()),
        Challenge(title: "5 Minutes of Silence", description: "Spend 5 minutes in complete silence", category: .meditation, isCompleted: false, date: Date()),
        Challenge(title: "Write a Warm Thought", description: "Write a warm thought about yourself", category: .selfCare, isCompleted: false, date: Date()),
        Challenge(title: "Deep Breathing", description: "Take 10 deep breaths mindfully", category: .breathing, isCompleted: false, date: Date())
    ]
}

struct Meditation: Identifiable, Codable {
    let id = UUID()
    let title: String
    let duration: TimeInterval
    let type: MeditationType
    var isCompleted: Bool
    let date: Date
}

enum MeditationType: String, CaseIterable, Codable {
    case breathing = "Breathing"
    case relaxation = "Relaxation"
    case focus = "Focus"
    
    var iconName: String {
        switch self {
        case .breathing: return "wind"
        case .relaxation: return "leaf.fill"
        case .focus: return "target"
        }
    }
}

struct DailyProgress: Identifiable, Codable {
    let id: UUID
    let date: Date
    var selectedMoods: [Mood]
    var completedHabits: [UUID]
    var completedChallenges: [UUID]
    var meditationCompleted: Bool
    
    init(id: UUID = UUID(), date: Date, selectedMoods: [Mood], completedHabits: [UUID], completedChallenges: [UUID], meditationCompleted: Bool) {
        self.id = id
        self.date = date
        self.selectedMoods = selectedMoods
        self.completedHabits = completedHabits
        self.completedChallenges = completedChallenges
        self.meditationCompleted = meditationCompleted
    }
    
    var completionPercentage: Double {
        let totalTasks = 4.0 
        var completed = 0.0
        
        if !selectedMoods.isEmpty { completed += 1 }
        if !completedHabits.isEmpty { completed += 1 }
        if !completedChallenges.isEmpty { completed += 1 }
        if meditationCompleted { completed += 1 }
        
        return completed / totalTasks
    }
}
