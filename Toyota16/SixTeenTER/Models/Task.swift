import Foundation

enum TaskPriority: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
    
    var displayName: String {
        return self.rawValue
    }
}

enum TaskType: String, CaseIterable, Codable {
    case task = "Task"
    case challenge = "Mini-Challenge"
    
    var displayName: String {
        return self.rawValue
    }
}

enum TaskFrequency: String, CaseIterable, Codable {
    case once = "Once"
    case daily = "Daily"
    case weekly = "Several times a week"
    
    var displayName: String {
        return self.rawValue
    }
}

struct TaskModel: Identifiable, Codable {
    let id: UUID
    var title: String
    var type: TaskType
    var priority: TaskPriority
    var frequency: TaskFrequency
    var note: String
    var whyImportant: String
    var isCompleted: Bool
    var completedDates: [Date]
    var createdDate: Date
    var streakDays: Int
    
    init(title: String,
         type: TaskType = .task,
         priority: TaskPriority = .medium,
         frequency: TaskFrequency = .once,
         note: String = "",
         whyImportant: String = "") {
        self.id = UUID()
        self.title = title
        self.type = type
        self.priority = priority
        self.frequency = frequency
        self.note = note
        self.whyImportant = whyImportant
        self.isCompleted = false
        self.completedDates = []
        self.createdDate = Date()
        self.streakDays = 0
    }
    
    init(id: UUID, title: String, type: TaskType, priority: TaskPriority, frequency: TaskFrequency,
         note: String, whyImportant: String, isCompleted: Bool, completedDates: [Date], createdDate: Date, streakDays: Int) {
        self.id = id
        self.title = title
        self.type = type
        self.priority = priority
        self.frequency = frequency
        self.note = note
        self.whyImportant = whyImportant
        self.isCompleted = isCompleted
        self.completedDates = completedDates
        self.createdDate = createdDate
        self.streakDays = streakDays
    }
    
    mutating func markCompleted() {
        isCompleted = true
        completedDates.append(Date())
        updateStreak()
    }
    
    mutating func markIncomplete() {
        isCompleted = false
        if let lastDate = completedDates.last, 
           Calendar.current.isDateInToday(lastDate) {
            completedDates.removeLast()
        }
        updateStreak()
    }
    
    private mutating func updateStreak() {
        let calendar = Calendar.current
        let today = Date()
        var streak = 0
        
        let sortedDates = completedDates.sorted(by: >)
        
        for date in sortedDates {
            let daysDifference = calendar.dateComponents([.day], from: date, to: today).day ?? 0
            
            if daysDifference == streak {
                streak += 1
            } else {
                break
            }
        }
        
        streakDays = streak
    }
}
