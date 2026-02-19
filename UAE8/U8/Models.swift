import Foundation

enum WorkoutType: String, CaseIterable, Identifiable, Codable {
    case strength = "Strength"
    case cardio = "Cardio"
    case technique = "Technique"
    case stretching = "Stretching"
    case functional = "Functional"
    case other = "Other"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .strength: return "Strength"
        case .cardio: return "Cardio"
        case .technique: return "Technique"
        case .stretching: return "Stretching"
        case .functional: return "Functional"
        case .other: return "Other"
        }
    }
}

enum DayOfWeek: String, CaseIterable, Identifiable, Codable {
    case monday = "Mon"
    case tuesday = "Tue"
    case wednesday = "Wed"
    case thursday = "Thu"
    case friday = "Fri"
    case saturday = "Sat"
    case sunday = "Sun"
    
    var id: String { rawValue }
    
    var fullName: String {
        switch self {
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        case .sunday: return "Sunday"
        }
    }
}

struct Workout: Identifiable, Codable {
    let id: UUID
    var day: DayOfWeek
    var type: WorkoutType
    var note: String
    var isCompleted: Bool
    var completedDate: Date?
    var lastModified: Date
    
    init(day: DayOfWeek, type: WorkoutType, note: String = "") {
        self.id = UUID()
        self.day = day
        self.type = type
        self.note = note
        self.isCompleted = false
        self.completedDate = nil
        self.lastModified = Date()
    }
}

enum HistoryActionType: String, Codable {
    case added = "added workout"
    case modified = "modified workout"
    case completed = "marked completed"
}

struct HistoryEntry: Identifiable, Codable {
    let id = UUID()
    let day: DayOfWeek
    let workoutType: WorkoutType
    let note: String
    let actionType: HistoryActionType
    let date: Date
    
    var monthYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct CategorySummary: Identifiable {
    let id = UUID()
    let type: WorkoutType
    let count: Int
    let days: [DayOfWeek]
}
