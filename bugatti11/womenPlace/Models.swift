import Foundation

struct TaskG: Identifiable, Codable {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
    var isHabit: Bool = false
    var icon: String = "circle"
    var time: Date?
    var repeatDaily: Bool = false
    var createdAt: Date = Date()
    var completedDates: [Date] = []
    
    var streak: Int {
        guard isHabit else { return 0 }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var currentStreak = 0
        
        for i in 0..<365 {
            let date = calendar.date(byAdding: .day, value: -i, to: today)!
            let dayStart = calendar.startOfDay(for: date)
            
            if completedDates.contains(where: { calendar.isDate($0, inSameDayAs: dayStart) }) {
                currentStreak += 1
            } else if i > 0 {
                break
            }
        }
        
        return currentStreak
    }
}

enum Mood: String, CaseIterable, Codable {
    case happy = "face.smiling"
    case neutral = "face.dashed"
    case sad = "face.dashed.fill"
    case excited = "star.circle"
    case tired = "moon.circle"
    
    var displayName: String {
        switch self {
        case .happy: return "Happy"
        case .neutral: return "Neutral"
        case .sad: return "Sad"
        case .excited: return "Excited"
        case .tired: return "Tired"
        }
    }
}

struct DailyEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    var mood: Mood?
    var tasks: [TaskG] = []
    var dailyQuestion: String = ""
    var dailyAnswer: String = ""
    var completedTasks: [UUID] = []
    
    var progressPercentage: Double {
        guard !tasks.isEmpty else { return 0 }
        let completedCount = tasks.filter { $0.isCompleted }.count
        return Double(completedCount) / Double(tasks.count)
    }
}

struct DailyQuestions {
    static let questions = [
        "What is the most important thing for you today?",
        "What are you grateful for right now?",
        "How do you want to feel at the end of today?",
        "What small step will make you proud?",
        "What would make today meaningful?",
        "What do you need to take care of yourself today?",
        "What are you looking forward to?",
        "How can you be kind to yourself today?",
        "What would help you feel more peaceful?",
        "What deserves your attention today?"
    ]
    
    static func randomQuestion() -> String {
        return questions.randomElement() ?? questions[0]
    }
}
