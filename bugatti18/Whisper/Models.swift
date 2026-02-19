import Foundation

struct Mood: Identifiable, Codable {
    let id = UUID()
    let emoji: String
    let name: String
    let date: Date
    
    static let defaultMoods = [
        Mood(emoji: "😊", name: "Happy", date: Date()),
        Mood(emoji: "😌", name: "Calm", date: Date()),
        Mood(emoji: "😴", name: "Tired", date: Date()),
        Mood(emoji: "😤", name: "Frustrated", date: Date()),
        Mood(emoji: "🥰", name: "Loved", date: Date()),
        Mood(emoji: "😔", name: "Sad", date: Date()),
        Mood(emoji: "🤗", name: "Grateful", date: Date())
    ]
}

struct GratitudeEntry: Identifiable, Codable {
    let id: UUID
    var text: String
    let date: Date
    
    init(text: String, date: Date = Date()) {
        self.id = UUID()
        self.text = text
        self.date = date
    }
}

struct Habit: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: HabitCategory
    var icon: String
    var frequency: HabitFrequency
    var whyImportant: String
    let createdDate: Date
    var completedDates: [Date]
    
    init(name: String, category: HabitCategory, icon: String, frequency: HabitFrequency, whyImportant: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.icon = icon
        self.frequency = frequency
        self.whyImportant = whyImportant
        self.createdDate = Date()
        self.completedDates = []
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
    
    var isCompletedToday: Bool {
        let calendar = Calendar.current
        return completedDates.contains { calendar.isDate($0, inSameDayAs: Date()) }
    }
    
    mutating func toggleCompletion() {
        let calendar = Calendar.current
        let today = Date()
        
        if let existingIndex = completedDates.firstIndex(where: { calendar.isDate($0, inSameDayAs: today) }) {
            completedDates.remove(at: existingIndex)
        } else {
            completedDates.append(today)
        }
    }
}

enum HabitCategory: String, CaseIterable, Codable {
    case body = "Body"
    case soul = "Soul"
    case hobby = "Hobby"
    case communication = "Communication"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .body: return "figure.walk"
        case .soul: return "heart.fill"
        case .hobby: return "paintbrush.fill"
        case .communication: return "person.2.fill"
        case .other: return "star.fill"
        }
    }
}

enum HabitFrequency: String, CaseIterable, Codable {
    case once = "Once"
    case daily = "Daily"
    case weekly = "Several times a week"
    
    var description: String {
        return self.rawValue
    }
}

struct DailyQuestion: Identifiable, Codable {
    let id: UUID
    let question: String
    var answer: String
    let date: Date
    
    init(question: String, answer: String = "", date: Date = Date()) {
        self.id = UUID()
        self.question = question
        self.answer = answer
        self.date = date
    }
    
    static let questions = [
        "What made you happy today?",
        "What are you most grateful for right now?",
        "What small win did you have today?",
        "What made you smile today?",
        "What act of kindness did you witness or perform?",
        "What challenged you today and how did you overcome it?",
        "What are you looking forward to tomorrow?"
    ]
}

struct DailyEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    var selectedMoods: [Mood]
    var gratitudeEntries: [GratitudeEntry]
    var dailyQuestion: DailyQuestion?
    var completedHabits: [UUID] 
    
    init(date: Date = Date()) {
        self.id = UUID()
        self.date = date
        self.selectedMoods = []
        self.gratitudeEntries = []
        self.dailyQuestion = nil
        self.completedHabits = []
    }
    
    var progressPercentage: Double {
        let totalPossibleActions = 5
        let completedActions = completedHabits.count + gratitudeEntries.count
        return min(Double(completedActions) / Double(totalPossibleActions), 1.0)
    }
}
