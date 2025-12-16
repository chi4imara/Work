import Foundation

struct Idea: Identifiable, Codable {
    let id: UUID
    var title: String
    var date: Date?
    var category: IdeaCategory
    var description: String
    var status: IdeaStatus
    var memory: String?
    var createdAt: Date
    var updatedAt: Date
    
    init(title: String, date: Date? = nil, category: IdeaCategory = .other, description: String = "", status: IdeaStatus = .planned) {
        self.id = UUID()
        self.title = title
        self.date = date
        self.category = category
        self.description = description
        self.status = status
        self.memory = nil
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    var dateString: String {
        guard let date = date else { return "No date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var shortDateString: String {
        guard let date = date else { return "No date" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

enum IdeaCategory: String, CaseIterable, Codable {
    case walk = "Walk"
    case photo = "Photo"
    case shopping = "Shopping"
    case home = "Home Meeting"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .walk:
            return "figure.walk"
        case .photo:
            return "camera"
        case .shopping:
            return "bag"
        case .home:
            return "house"
        case .other:
            return "star"
        }
    }
}

enum IdeaStatus: String, CaseIterable, Codable {
    case planned = "Planned"
    case completed = "Completed"
    
    var icon: String {
        switch self {
        case .planned:
            return "clock"
        case .completed:
            return "checkmark.circle"
        }
    }
}

enum FilterType: String, CaseIterable {
    case all = "All"
    case planned = "Planned"
    case completed = "Completed"
}

enum TabItem: String, CaseIterable {
    case ideas = "Ideas"
    case calendar = "Calendar"
    case memories = "Memories"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .ideas:
            return "message"
        case .calendar:
            return "calendar"
        case .memories:
            return "star"
        case .statistics:
            return "chart.bar"
        case .settings:
            return "gearshape"
        }
    }
}
