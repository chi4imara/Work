import Foundation

struct Meeting: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var description: String
    var location: String?
    var date: Date
    var createdAt: Date
    var updatedAt: Date
    
    init(title: String, description: String, location: String? = nil, date: Date = Date()) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.location = location
        self.date = date
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    mutating func update(title: String, description: String, location: String?, date: Date) {
        self.title = title
        self.description = description
        self.location = location
        self.date = date
        self.updatedAt = Date()
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    var shortDescription: String {
        let lines = description.components(separatedBy: .newlines)
        let firstTwoLines = Array(lines.prefix(2))
        let result = firstTwoLines.joined(separator: "\n")
        return result.count > 100 ? String(result.prefix(100)) + "..." : result
    }
}

enum FilterPeriod: String, CaseIterable {
    case today = "Today"
    case week = "Week"
    case month = "Month"
    case all = "All"
    
    var localizedString: String {
        switch self {
        case .today: return "Today"
        case .week: return "Week"
        case .month: return "Month"
        case .all: return "All"
        }
    }
    
    func dateRange() -> (start: Date, end: Date)? {
        let calendar = Calendar.current
        let now = Date()
        
        switch self {
        case .today:
            let startOfDay = calendar.startOfDay(for: now)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            return (startOfDay, endOfDay)
        case .week:
            let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
            let endOfWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: startOfWeek)!
            return (startOfWeek, endOfWeek)
        case .month:
            let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
            let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
            return (startOfMonth, endOfMonth)
        case .all:
            return nil
        }
    }
}

enum StatisticsPeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
    
    var localizedString: String {
        switch self {
        case .week: return "Week"
        case .month: return "Month"
        case .year: return "Year"
        }
    }
}
