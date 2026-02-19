import Foundation

struct HistoryEntry: Identifiable, Codable {
    let id = UUID()
    let practiceId: UUID
    let practiceName: String
    let practiceType: PracticeType
    let duration: Int
    let completedAt: Date
    var note: String
    
    init(practice: Practice, note: String = "") {
        self.practiceId = practice.id
        self.practiceName = practice.name
        self.practiceType = practice.type
        self.duration = practice.duration
        self.completedAt = Date()
        self.note = note
    }
    
    init(practiceId: UUID, practiceName: String, practiceType: PracticeType, duration: Int, completedAt: Date, note: String = "") {
        self.practiceId = practiceId
        self.practiceName = practiceName
        self.practiceType = practiceType
        self.duration = duration
        self.completedAt = completedAt
        self.note = note
    }
}

struct DayProgress: Identifiable {
    let id = UUID()
    let date: Date
    var entries: [HistoryEntry]
    var totalDuration: Int {
        entries.reduce(0) { $0 + $1.duration }
    }
    var practicesCount: Int {
        entries.count
    }
}

struct StreakData {
    var currentStreak: Int
    var longestStreak: Int
    var totalDays: Int
    
    init() {
        self.currentStreak = 0
        self.longestStreak = 0
        self.totalDays = 0
    }
}