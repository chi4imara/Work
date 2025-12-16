import Foundation

struct Habit: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    
    static let defaultHabits = [
        Habit(title: "Didn't complain", description: "A day without complaints — a day with attention to the good"),
        Habit(title: "Didn't worry", description: "Without anxiety — more energy for important things"),
        Habit(title: "Didn't rush", description: "When you don't rush — time works for you"),
        Habit(title: "Didn't get irritated", description: "Calmness is a choice, not a circumstance"),
        Habit(title: "Didn't compare myself", description: "Your path is unique and valuable"),
        Habit(title: "Didn't procrastinate", description: "Action brings clarity and confidence"),
        Habit(title: "Didn't blame others", description: "Taking responsibility gives you power")
    ]
}

struct DayEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    var checkedHabits: Set<String> = []
    var note: String = ""
    
    var hasAnyChecked: Bool {
        !checkedHabits.isEmpty
    }
    
    var checkedHabitsCount: Int {
        checkedHabits.count
    }
}

struct UserValue: Identifiable, Codable {
    let id: UUID
    var text: String
    let createdAt: Date
    
    init(text: String) {
        self.id = UUID()
        self.text = text
        self.createdAt = Date()
    }
}

struct SupportPhrase: Identifiable, Codable {
    let id: UUID
    var text: String
    let createdAt: Date
    
    init(text: String) {
        self.id = UUID()
        self.text = text
        self.createdAt = Date()
    }
}

struct Statistics {
    let habitStats: [String: Int]
    let totalDays: Int
    let currentStreak: Int
    let thisWeekCount: Int
    let thisMonthCount: Int
    
    static let empty = Statistics(
        habitStats: [:],
        totalDays: 0,
        currentStreak: 0,
        thisWeekCount: 0,
        thisMonthCount: 0
    )
}

enum AppState {
    case splash
    case onboarding
    case main
}

struct DefaultValues {
    static let inspirationalPhrases = [
        "Today it's enough to just be attentive.",
        "Calmness is more important than haste.",
        "Silence is also an answer.",
        "Not everything requires a reaction.",
        "You can slow down.",
        "I'm managing.",
        "Nothing terrible if today is just calm."
    ]
    
    static let defaultPrinciples = [
        "Calmness is more important than haste.",
        "I don't have to control everything.",
        "Silence is also an answer.",
        "Nothing terrible if today is just calm."
    ]
    
    static let defaultSupportPhrases = [
        "I'm managing.",
        "Not everything requires a reaction.",
        "You can slow down."
    ]
}
