import Foundation
import SwiftUI

struct Mood: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let emoji: String
    let color: Color
    
    private enum CodingKeys: String, CodingKey {
        case name, emoji, colorHex
    }
    
    init(name: String, emoji: String, color: Color) {
        self.id = UUID()
        self.name = name
        self.emoji = emoji
        self.color = color
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.emoji = try container.decode(String.self, forKey: .emoji)
        let colorHex = try container.decode(String.self, forKey: .colorHex)
        self.color = Color(hex: colorHex) ?? .blue
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(emoji, forKey: .emoji)
        try container.encode(color.toHex(), forKey: .colorHex)
    }
    
    static let allMoods: [Mood] = [
        Mood(name: "Happy", emoji: "😊", color: .yellow),
        Mood(name: "Calm", emoji: "😌", color: .blue),
        Mood(name: "Energetic", emoji: "⚡", color: .orange),
        Mood(name: "Tired", emoji: "😴", color: .purple),
        Mood(name: "Anxious", emoji: "😰", color: .red),
        Mood(name: "Sad", emoji: "😢", color: .gray),
        Mood(name: "Inspired", emoji: "✨", color: .pink),
        Mood(name: "Grateful", emoji: "🙏", color: .green)
    ]
}

struct Ritual: Codable, Identifiable {
    let id: UUID
    var title: String
    var category: RitualCategory
    var frequency: RitualFrequency
    var description: String
    var isCompleted: Bool
    var completionDates: [Date]
    var createdDate: Date
    
    init(id: UUID = UUID(), title: String, category: RitualCategory, frequency: RitualFrequency = .daily, description: String = "", isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.category = category
        self.frequency = frequency
        self.description = description
        self.isCompleted = isCompleted
        self.completionDates = []
        self.createdDate = Date()
    }
    
    var streakCount: Int {
        let calendar = Calendar.current
        let sortedDates = completionDates.sorted(by: >)
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        for date in sortedDates {
            if calendar.isDate(date, inSameDayAs: currentDate) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return streak
    }
    
    static let defaultRituals: [Ritual] = [
        Ritual(title: "Morning Meditation", category: .mindfulness, description: "5 minutes of mindful breathing"),
        Ritual(title: "Gratitude Journal", category: .journaling, description: "Write 3 things you're grateful for"),
        Ritual(title: "Evening Walk", category: .physical, description: "Take a peaceful walk outside"),
        Ritual(title: "Deep Breathing", category: .mindfulness, description: "Practice deep breathing exercises")
    ]
}

enum RitualCategory: String, Codable, CaseIterable {
    case mindfulness = "Mindfulness"
    case physical = "Physical"
    case journaling = "Journaling"
    case creative = "Creative"
    case social = "Social"
    
    var color: Color {
        switch self {
        case .mindfulness: return .blue
        case .physical: return .green
        case .journaling: return .orange
        case .creative: return .purple
        case .social: return .pink
        }
    }
    
    var icon: String {
        switch self {
        case .mindfulness: return "leaf.fill"
        case .physical: return "figure.walk"
        case .journaling: return "pencil"
        case .creative: return "paintbrush.fill"
        case .social: return "person.2.fill"
        }
    }
}

enum RitualFrequency: String, Codable, CaseIterable {
    case daily = "Daily"
    case weekly = "Weekly"
    case oneTime = "One Time"
}

struct Challenge: Codable, Identifiable {
    let id: UUID
    let title: String
    let description: String
    let category: RitualCategory
    let difficulty: ChallengeDifficulty
    var isCompleted: Bool
    
    init(id: UUID = UUID(), title: String, description: String, category: RitualCategory, difficulty: ChallengeDifficulty, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.difficulty = difficulty
        self.isCompleted = isCompleted
    }
    
    static let dailyChallenges: [Challenge] = [
        Challenge(title: "5-Minute Meditation", description: "Take 5 minutes to focus on your breathing", category: .mindfulness, difficulty: .easy),
        Challenge(title: "Write 3 Gratitudes", description: "List three things you're grateful for today", category: .journaling, difficulty: .easy),
        Challenge(title: "Take a Mindful Walk", description: "Go for a 10-minute walk and notice your surroundings", category: .physical, difficulty: .medium),
        Challenge(title: "Call a Friend", description: "Reach out to someone you care about", category: .social, difficulty: .medium),
        Challenge(title: "Creative Expression", description: "Spend 15 minutes on any creative activity", category: .creative, difficulty: .medium),
        Challenge(title: "Digital Detox Hour", description: "Spend one hour without any screens", category: .mindfulness, difficulty: .hard),
        Challenge(title: "Random Act of Kindness", description: "Do something kind for someone else", category: .social, difficulty: .easy)
    ]
}

enum ChallengeDifficulty: String, Codable, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var color: Color {
        switch self {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
}

struct DailyEntry: Codable, Identifiable {
    let id: UUID
    let date: Date
    var mood: Mood?
    var note: String
    var completedRituals: Set<UUID>
    var completedChallenges: Set<UUID>
    var gratitudes: [String]
    
    init(id: UUID = UUID(), date: Date, mood: Mood? = nil, note: String = "") {
        self.id = id
        self.date = date
        self.mood = mood
        self.note = note
        self.completedRituals = []
        self.completedChallenges = []
        self.gratitudes = []
    }
    
    var isComplete: Bool {
        mood != nil && (!completedRituals.isEmpty || !completedChallenges.isEmpty)
    }
    
    var completionPercentage: Double {
        let moodWeight = mood != nil ? 0.4 : 0.0
        let ritualsWeight = completedRituals.isEmpty ? 0.0 : 0.4
        let challengesWeight = completedChallenges.isEmpty ? 0.0 : 0.2
        return moodWeight + ritualsWeight + challengesWeight
    }
}

extension Color {
    init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return nil
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    func toHex() -> String {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return "000000"
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
}

struct AppColors {
    static let primary = Color.blue
    static let secondary = Color.yellow
    static let accent = Color.orange
    static let background = Color.white
    static let text = Color.black
    static let lightGray = Color.gray.opacity(0.3)
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    
    static let backgroundGradient = LinearGradient(
        colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1), Color.pink.opacity(0.1)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [Color.white, Color.blue.opacity(0.05)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
