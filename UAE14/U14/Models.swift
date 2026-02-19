import Foundation

struct PullUpEntry: Identifiable, Codable {
    let id: UUID
    var date: Date
    var count: Int
    var comment: String
    
    init(id: UUID = UUID(), date: Date = Date(), count: Int = 0, comment: String = "") {
        self.id = id
        self.date = date
        self.count = count
        self.comment = comment
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}

enum TimePeriod: String, CaseIterable {
    case all = "All"
    case week = "Week"
    case month = "Month"
    
    var days: Int? {
        switch self {
        case .all:
            return nil
        case .week:
            return 7
        case .month:
            return 30
        }
    }
}

struct Statistics {
    let totalEntries: Int
    let totalPullUps: Int
    let averagePerDay: Double
    let maxInOneDay: Int
    let bestDay: Date?
    
    init(entries: [PullUpEntry]) {
        self.totalEntries = entries.count
        self.totalPullUps = entries.reduce(0) { $0 + $1.count }
        self.averagePerDay = totalEntries > 0 ? Double(totalPullUps) / Double(totalEntries) : 0
        self.maxInOneDay = entries.map { $0.count }.max() ?? 0
        self.bestDay = entries.max { $0.count < $1.count }?.date
    }
}

enum TabItem: String, CaseIterable {
    case diary = "Diary"
    case progress = "Progress"
    case achievements = "Achievements"
    case workouts = "Workouts"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .diary:
            return "book.fill"
        case .progress:
            return "chart.line.uptrend.xyaxis"
        case .achievements:
            return "trophy.fill"
        case .workouts:
            return "figure.strengthtraining.traditional"
        case .settings:
            return "gearshape.fill"
        }
    }
    
    var title: String {
        return self.rawValue
    }
}
