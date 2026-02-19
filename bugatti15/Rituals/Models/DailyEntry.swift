import Foundation

struct DailyEntry: Identifiable, Codable {
    let id: UUID
    let date: Date
    var moods: [Mood] = []
    var completedGoals: [UUID] = []
    var dailyQuestion: String?
    var dailyAnswer: String?
    var progressPercentage: Double = 0.0
    
    init(date: Date = Date()) {
        self.id = UUID()
        self.date = date
    }
    
    mutating func addMood(_ mood: Mood) {
        moods.append(mood)
    }
    
    mutating func completeGoal(_ goalId: UUID) {
        if !completedGoals.contains(goalId) {
            completedGoals.append(goalId)
        }
    }
    
    mutating func uncompleteGoal(_ goalId: UUID) {
        completedGoals.removeAll { $0 == goalId }
    }
    
    mutating func updateProgress(totalGoals: Int) {
        guard totalGoals > 0 else {
            progressPercentage = 0.0
            return
        }
        progressPercentage = Double(completedGoals.count) / Double(totalGoals)
    }
    
    mutating func setDailyQuestion(_ question: String, answer: String? = nil) {
        dailyQuestion = question
        dailyAnswer = answer
    }
}

struct DailyQuestions {
    static let questions = [
        "What will bring you joy today?",
        "What small thing can you do for yourself today?",
        "What are you grateful for right now?",
        "How do you want to feel at the end of today?",
        "What would make today special?",
        "What's one thing you're looking forward to?",
        "How can you show yourself kindness today?",
        "What would your best friend tell you right now?",
        "What's something beautiful you noticed today?",
        "What made you smile recently?"
    ]
    
    static func randomQuestion() -> String {
        return questions.randomElement() ?? questions[0]
    }
}
