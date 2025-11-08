import Foundation

struct WonderEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var description: String
    var date: Date
    var time: Date
    let createdAt: Date
    var updatedAt: Date
    
    init(title: String, description: String = "", date: Date = Date(), time: Date = Date()) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.date = date
        self.time = time
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    mutating func update(title: String, description: String, date: Date, time: Date) {
        self.title = title
        self.description = description
        self.date = date
        self.time = time
        self.updatedAt = Date()
    }
    
    var displayDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    var displayTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: time)
    }
    
    var displayDateTime: String {
        return "\(displayDate), \(displayTime)"
    }
    
    var shortDescription: String {
        if description.isEmpty {
            return ""
        }
        let lines = description.components(separatedBy: .newlines)
        let firstTwoLines = Array(lines.prefix(2)).joined(separator: "\n")
        return firstTwoLines.count > 100 ? String(firstTwoLines.prefix(100)) + "..." : firstTwoLines
    }
}

enum TimePeriod: String, CaseIterable {
    case today = "Today"
    case week = "Week"
    case month = "Month"
    case all = "All"
}

enum SortOrder: String, CaseIterable {
    case newest = "Newest First"
    case oldest = "Oldest First"
}
