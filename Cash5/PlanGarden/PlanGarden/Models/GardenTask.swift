import Foundation

enum WorkType: String, CaseIterable, Codable {
    case planting = "Planting"
    case watering = "Watering"
    case fertilizing = "Fertilizing"
    case pruning = "Pruning/Harvesting"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .planting: return "leaf.fill"
        case .watering: return "drop.fill"
        case .fertilizing: return "flask.fill"
        case .pruning: return "scissors"
        case .other: return "ellipsis.circle.fill"
        }
    }
}

enum Frequency: String, CaseIterable, Codable {
    case once = "Once"
    case daily = "Daily"
    case weekly = "Weekly"
    
    var displayName: String {
        return self.rawValue
    }
}

enum TaskStatus: String, Codable {
    case pending = "pending"
    case completed = "completed"
    case archived = "archived"
}

struct Culture: Codable, Identifiable, Hashable {
    let id = UUID()
    let name: String
    
    static let predefined = [
        Culture(name: "Tomatoes"),
        Culture(name: "Cucumbers"),
        Culture(name: "Peppers"),
        Culture(name: "Carrots"),
        Culture(name: "Lettuce"),
        Culture(name: "Herbs"),
        Culture(name: "Roses"),
        Culture(name: "Apple Trees"),
        Culture(name: "Strawberries"),
        Culture(name: "Potatoes")
    ]
}

struct GardenTask: Codable, Identifiable {
    let id = UUID()
    var culture: Culture
    var workType: WorkType
    var date: Date
    var time: Date?
    var frequency: Frequency
    var weekDay: Int?
    var note: String
    var status: TaskStatus
    var completedDates: [String]
    var archivedDate: Date?
    
    init(culture: Culture, workType: WorkType, date: Date, time: Date? = nil, frequency: Frequency, weekDay: Int? = nil, note: String = "", status: TaskStatus = .pending) {
        self.culture = culture
        self.workType = workType
        self.date = date
        self.time = time
        self.frequency = frequency
        self.weekDay = weekDay
        self.note = note
        self.status = status
        self.completedDates = []
        self.archivedDate = nil
    }
    
    func isRelevantFor(date: Date) -> Bool {
        let calendar = Calendar.current
        let targetDateString = DateFormatter.dayFormatter.string(from: date)
        
        switch frequency {
        case .once:
            return calendar.isDate(self.date, inSameDayAs: date)
        case .daily:
            return calendar.compare(date, to: self.date, toGranularity: .day) != .orderedAscending
        case .weekly:
            guard let weekDay = weekDay else { return false }
            let dateWeekday = calendar.component(.weekday, from: date)
            return dateWeekday == weekDay && calendar.compare(date, to: self.date, toGranularity: .day) != .orderedAscending
        }
    }
    
    func isCompletedFor(date: Date) -> Bool {
        let dateString = DateFormatter.dayFormatter.string(from: date)
        return completedDates.contains(dateString)
    }
    
    mutating func markCompleted(for date: Date) {
        let dateString = DateFormatter.dayFormatter.string(from: date)
        if !completedDates.contains(dateString) {
            completedDates.append(dateString)
        }
    }
    
    mutating func markNotCompleted(for date: Date) {
        let dateString = DateFormatter.dayFormatter.string(from: date)
        completedDates.removeAll { $0 == dateString }
    }
    
    mutating func archive() {
        status = .archived
        archivedDate = Date()
    }
    
    mutating func restore() {
        status = .pending
        archivedDate = nil
    }
}

extension DateFormatter {
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    static let displayTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    static let displayDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
