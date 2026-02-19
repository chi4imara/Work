import Foundation

struct WorkoutRecord: Identifiable, Codable {
    let id: UUID
    var date: Date
    var exercise: String
    var weight: Double
    var repetitions: Int
    var comment: String
    
    init(date: Date = Date(), exercise: String = "", weight: Double = 0, repetitions: Int = 0, comment: String = "") {
        self.id = UUID()
        self.date = date
        self.exercise = exercise
        self.weight = weight
        self.repetitions = repetitions
        self.comment = comment
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var hasComment: Bool {
        return !comment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

struct ExerciseGroup: Identifiable {
    let id = UUID()
    let name: String
    let records: [WorkoutRecord]
    
    var recordCount: Int {
        return records.count
    }
}

enum AppTab: String, CaseIterable {
    case newRecord = "New"
    case history = "History"
    case exercises = "Exercises"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var title: String {
        switch self {
        case .newRecord:
            return "New"
        case .history:
            return "History"
        case .exercises:
            return "Exercises"
        case .statistics:
            return "Statistics"
        case .settings:
            return "Settings"
        }
    }
    
    var iconName: String {
        switch self {
        case .newRecord:
            return "plus.circle"
        case .history:
            return "clock"
        case .exercises:
            return "dumbbell"
        case .statistics:
            return "chart.bar.fill"
        case .settings:
            return "gear"
        }
    }
}
