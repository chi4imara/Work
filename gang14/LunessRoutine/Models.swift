import Foundation

struct DailyPhrase: Identifiable, Codable {
    let id: UUID
    let text: String
    let dateAdded: Date
    var isFavorite: Bool = true
    
    init(text: String, dateAdded: Date = Date()) {
        self.id = UUID()
        self.text = text
        self.dateAdded = dateAdded
    }
}

struct DailyState: Codable {
    let date: Date
    var completed: Bool = false
    var completionsCount: Int = 0
    var completedAt: Date?
    var lightOff: Bool = false
    
    init(date: Date = Date()) {
        self.date = Calendar.current.startOfDay(for: date)
    }
}

struct PracticeStep {
    let id: Int
    let title: String
    let description: String
    
    static let allSteps = [
        PracticeStep(
            id: 1,
            title: "Acknowledge the End",
            description: "Recognize that the day is coming to an end. Everything that didn't get done can wait until tomorrow."
        ),
        PracticeStep(
            id: 2,
            title: "Release Your Thoughts",
            description: "Imagine your thoughts gently dispersing like smoke, and your mind becoming light."
        ),
        PracticeStep(
            id: 3,
            title: "Thank the Day",
            description: "Remember one good thing that happened and thank yourself for the day you've lived."
        )
    ]
}

extension DailyPhrase {
    static let defaultPhrases = [
        "Today everything is done. The rest can wait until morning.",
        "You did your best today. Now it's time to rest.",
        "Let go of what didn't happen. Tomorrow is a new beginning.",
        "Your mind deserves peace. Let the day flow away.",
        "Every ending is also a beginning. Rest well.",
        "You are enough. Today was enough. Rest is deserved.",
        "The day is complete. Your soul can now be at peace.",
        "Release the day with gratitude. Tomorrow will bring new opportunities.",
        "You've carried enough today. Now let yourself be light.",
        "The evening brings wisdom. Listen to the silence within."
    ].map { DailyPhrase(text: $0) }
}
