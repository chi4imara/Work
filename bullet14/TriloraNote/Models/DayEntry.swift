import Foundation

struct DayEntry: Identifiable, Codable, Hashable {
    let id = UUID()
    let date: Date
    var morningEntry: String?
    var dayEntry: String?
    var eveningEntry: String?
    
    var hasAnyEntry: Bool {
        return !(morningEntry?.isEmpty ?? true) || 
               !(dayEntry?.isEmpty ?? true) || 
               !(eveningEntry?.isEmpty ?? true)
    }
    
    var completedPeriodsCount: Int {
        var count = 0
        if !(morningEntry?.isEmpty ?? true) { count += 1 }
        if !(dayEntry?.isEmpty ?? true) { count += 1 }
        if !(eveningEntry?.isEmpty ?? true) { count += 1 }
        return count
    }
}

enum TimeOfDay: CaseIterable {
    case morning, day, evening
    
    var title: String {
        switch self {
        case .morning:
            return "What did you notice this morning?"
        case .day:
            return "What did you notice during the day?"
        case .evening:
            return "What did you notice this evening?"
        }
    }
    
    var placeholder: String {
        switch self {
        case .morning:
            return "What did you feel when you woke up?"
        case .day:
            return "What moment made the day special?"
        case .evening:
            return "What will remain in memory from this day?"
        }
    }
    
    var icon: String {
        switch self {
        case .morning:
            return "sun.max"
        case .day:
            return "sun.max.fill"
        case .evening:
            return "moon"
        }
    }
    
    static func current() -> TimeOfDay {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return .morning
        case 12..<18:
            return .day
        default:
            return .evening
        }
    }
}
