import Foundation
import SwiftUI

enum EnergyLevel: Int, CaseIterable, Codable {
    case veryLow = 1
    case low = 2
    case medium = 3
    case good = 4
    case high = 5
    case veryHigh = 6
    case excellent = 7
    
    var icon: String {
        switch self {
        case .veryLow: return "battery.0"
        case .low: return "battery.25"
        case .medium: return "battery.50"
        case .good: return "battery.75"
        case .high: return "battery.100"
        case .veryHigh: return "bolt.fill"
        case .excellent: return "star.fill"
        }
    }
    
    var title: String {
        switch self {
        case .veryLow: return "Very Low"
        case .low: return "Low"
        case .medium: return "Medium"
        case .good: return "Good"
        case .high: return "High"
        case .veryHigh: return "Very High"
        case .excellent: return "Excellent"
        }
    }
    
    var color: Color {
        switch self {
        case .veryLow, .low: return .red
        case .medium: return .orange
        case .good: return .yellow
        case .high, .veryHigh: return ColorManager.primaryBlue
        case .excellent: return ColorManager.primaryYellow
        }
    }
}

enum HabitCategory: String, CaseIterable, Codable {
    case breathing = "breathing"
    case morningRituals = "morning_rituals"
    case achievementDiary = "achievement_diary"
    case miniChallenge = "mini_challenge"
    
    var title: String {
        switch self {
        case .breathing: return "Breathing Practices"
        case .morningRituals: return "Morning Rituals"
        case .achievementDiary: return "Achievement Diary"
        case .miniChallenge: return "Mini Challenge"
        }
    }
    
    var icon: String {
        switch self {
        case .breathing: return "lungs.fill"
        case .morningRituals: return "sunrise.fill"
        case .achievementDiary: return "book.fill"
        case .miniChallenge: return "target"
        }
    }
}

enum HabitFrequency: String, CaseIterable, Codable {
    case once = "once"
    case daily = "daily"
    case weekly = "weekly"
    
    var title: String {
        switch self {
        case .once: return "Once"
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        }
    }
}

struct Habit: Identifiable, Codable {
    var id: UUID
    var name: String
    var category: HabitCategory
    var frequency: HabitFrequency
    var icon: String
    var whyImportant: String
    var createdDate: Date
    var completedDates: [Date]
    
    var isCompleted: Bool {
        guard let lastDate = completedDates.last else { return false }
        return Calendar.current.isDateInToday(lastDate)
    }
    
    var streakDays: Int {
        let calendar = Calendar.current
        let today = Date()
        var streak = 0
        
        for i in 0..<365 {
            let date = calendar.date(byAdding: .day, value: -i, to: today)!
            let isCompleted = completedDates.contains { calendar.isDate($0, inSameDayAs: date) }
            
            if isCompleted {
                streak += 1
            } else if i > 0 {
                break
            }
        }
        
        return streak
    }
    
    init(name: String, category: HabitCategory, frequency: HabitFrequency, icon: String, whyImportant: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.frequency = frequency
        self.icon = icon
        self.whyImportant = whyImportant
        self.createdDate = Date()
        self.completedDates = []
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(HabitCategory.self, forKey: .category)
        frequency = try container.decode(HabitFrequency.self, forKey: .frequency)
        icon = try container.decode(String.self, forKey: .icon)
        whyImportant = try container.decode(String.self, forKey: .whyImportant)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        completedDates = try container.decode([Date].self, forKey: .completedDates)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)
        try container.encode(frequency, forKey: .frequency)
        try container.encode(icon, forKey: .icon)
        try container.encode(whyImportant, forKey: .whyImportant)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(completedDates, forKey: .completedDates)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, category, frequency, icon, whyImportant, createdDate, completedDates
    }
}

struct MiniRitual: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let duration: Int
    let isForMorning: Bool
    let steps: [String]
    
    static let morningRituals = [
        MiniRitual(
            title: "Energy Breathing",
            description: "Deep breathing to energize your body",
            duration: 3,
            isForMorning: true,
            steps: ["Sit comfortably", "Inhale for 4 counts", "Hold for 4 counts", "Exhale for 6 counts", "Repeat 5 times"]
        ),
        MiniRitual(
            title: "Positive Visualization",
            description: "Visualize your successful day",
            duration: 5,
            isForMorning: true,
            steps: ["Close your eyes", "Imagine your perfect day", "See yourself succeeding", "Feel the positive emotions", "Open your eyes with confidence"]
        )
    ]
    
    static let eveningRituals = [
        MiniRitual(
            title: "Gratitude Reflection",
            description: "Reflect on today's positive moments",
            duration: 5,
            isForMorning: false,
            steps: ["Think of 3 good things today", "Feel grateful for each one", "Appreciate your efforts", "Set positive intention for tomorrow"]
        ),
        MiniRitual(
            title: "Calming Breath",
            description: "Relaxing breathing for better sleep",
            duration: 7,
            isForMorning: false,
            steps: ["Lie down comfortably", "Breathe in slowly", "Breathe out even slower", "Let go of today's stress", "Feel peaceful and calm"]
        )
    ]
}

struct DailyChallenge: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let category: HabitCategory
    
    static let challenges = [
        DailyChallenge(title: "Write 1 yesterday's achievement", description: "Think about something you accomplished yesterday and write it down", category: .achievementDiary),
        DailyChallenge(title: "5-minute mindful breathing", description: "Take a pause and do 5 minutes of conscious breathing", category: .breathing),
        DailyChallenge(title: "Give yourself a compliment", description: "Look in the mirror and say something nice about yourself", category: .morningRituals),
        DailyChallenge(title: "Write down 3 things you're grateful for", description: "List three things that make you feel grateful today", category: .achievementDiary),
        DailyChallenge(title: "Do 10 deep breaths with intention", description: "Take 10 deep breaths while setting a positive intention", category: .breathing),
        DailyChallenge(title: "Celebrate a small win", description: "Acknowledge and celebrate something small you did well today", category: .morningRituals)
    ]
}

struct DailyEntry: Identifiable, Codable {
    var id: UUID
    let date: Date
    var energyLevels: [EnergyLevel]
    var completedHabits: [UUID]
    var completedRitual: Bool
    var completedChallenge: Bool
    var notes: String
    
    var progressPercentage: Double {
        let totalTasks = 4.0
        var completed = 0.0
        
        if !energyLevels.isEmpty { completed += 1 }
        if completedRitual { completed += 1 }
        if completedChallenge { completed += 1 }
        if !completedHabits.isEmpty { completed += 1 }
        
        return completed / totalTasks
    }
    
    init(date: Date) {
        self.id = UUID()
        self.date = date
        self.energyLevels = []
        self.completedHabits = []
        self.completedRitual = false
        self.completedChallenge = false
        self.notes = ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        date = try container.decode(Date.self, forKey: .date)
        energyLevels = try container.decode([EnergyLevel].self, forKey: .energyLevels)
        completedHabits = try container.decode([UUID].self, forKey: .completedHabits)
        completedRitual = try container.decode(Bool.self, forKey: .completedRitual)
        completedChallenge = try container.decode(Bool.self, forKey: .completedChallenge)
        notes = try container.decode(String.self, forKey: .notes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(energyLevels, forKey: .energyLevels)
        try container.encode(completedHabits, forKey: .completedHabits)
        try container.encode(completedRitual, forKey: .completedRitual)
        try container.encode(completedChallenge, forKey: .completedChallenge)
        try container.encode(notes, forKey: .notes)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, date, energyLevels, completedHabits, completedRitual, completedChallenge, notes
    }
}
