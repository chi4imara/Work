import Foundation

struct Workout: Identifiable, Codable {
    let id: UUID
    var name: String
    var exercises: [Exercise]
    var note: String
    var createdAt: Date
    var lastPerformed: Date?
    
    init(name: String, exercises: [Exercise] = [], note: String = "") {
        self.id = UUID()
        self.name = name
        self.exercises = exercises
        self.note = note
        self.createdAt = Date()
        self.lastPerformed = nil
    }
    
    var exerciseCount: Int {
        exercises.count
    }
    
    var lastPerformedText: String {
        guard let lastPerformed = lastPerformed else {
            return "Never"
        }
        
        let calendar = Calendar.current
        if calendar.isDateInToday(lastPerformed) {
            return "Today"
        } else if calendar.isDateInYesterday(lastPerformed) {
            return "Yesterday"
        } else {
            let daysDifference = calendar.dateComponents([.day], from: lastPerformed, to: Date()).day ?? 0
            return "\(daysDifference) days ago"
        }
    }
    
    var isPerformedToday: Bool {
        guard let lastPerformed = lastPerformed else { return false }
        return Calendar.current.isDateInToday(lastPerformed)
    }
}
