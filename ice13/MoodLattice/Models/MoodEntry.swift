import Foundation

enum MoodType: String, CaseIterable, Codable {
    case happy = "😃"
    case calm = "🙂"
    case neutral = "😐"
    case sad = "😟"
    case angry = "😡"
    
    var name: String {
        switch self {
        case .happy: return "Joy"
        case .calm: return "Calm"
        case .neutral: return "Neutral"
        case .sad: return "Sad/Stress"
        case .angry: return "Anger"
        }
    }
    
    var color: String {
        switch self {
        case .happy: return "green"
        case .calm: return "blue"
        case .neutral: return "gray"
        case .sad: return "orange"
        case .angry: return "red"
        }
    }
}

struct MoodEntry: Identifiable, Codable, Equatable {
    let id: UUID
    let date: Date
    let mood: MoodType
    let note: String
    let createdAt: Date
    
    init(date: Date, mood: MoodType, note: String = "") {
        self.id = UUID()
        self.date = Calendar.current.startOfDay(for: date)
        self.mood = mood
        self.note = note
        self.createdAt = Date()
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    var shortNote: String {
        if note.isEmpty {
            return "No note"
        }
        let lines = note.components(separatedBy: .newlines)
        let firstLine = lines.first ?? ""
        return firstLine.count > 50 ? String(firstLine.prefix(50)) + "..." : firstLine
    }
}

struct MoodStatistics {
    let totalEntries: Int
    let currentStreak: Int
    let bestStreak: Int
    let monthlyDistribution: [MoodType: Int]
    let weeklyDistribution: [String: Int]
    let monthlyEntries: Int
    let monthlyMissed: Int
    let monthlyCompletion: Int
    
    static let empty = MoodStatistics(
        totalEntries: 0,
        currentStreak: 0,
        bestStreak: 0,
        monthlyDistribution: [:],
        weeklyDistribution: [:],
        monthlyEntries: 0,
        monthlyMissed: 0,
        monthlyCompletion: 0
    )
}
