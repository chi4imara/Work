import Foundation

struct PhotoshootScenario: Identifiable, Codable {
    let id: UUID
    var theme: String
    var location: String
    var date: Date
    var poses: String
    var props: String
    var comment: String
    var status: ScenarioStatus
    var category: ScenarioCategory
    let createdAt: Date
    
    init(theme: String, location: String, date: Date, poses: String, props: String, comment: String, status: ScenarioStatus = .planned, category: ScenarioCategory = .portrait) {
        self.id = UUID()
        self.theme = theme
        self.location = location
        self.date = date
        self.poses = poses
        self.props = props
        self.comment = comment
        self.status = status
        self.category = category
        self.createdAt = Date()
    }
}

enum ScenarioStatus: String, CaseIterable, Codable {
    case planned = "Planned"
    case completed = "Completed"
    
    var icon: String {
        switch self {
        case .planned:
            return "circle"
        case .completed:
            return "checkmark.circle.fill"
        }
    }
    
    var color: String {
        switch self {
        case .planned:
            return "appPlanned"
        case .completed:
            return "appCompleted"
        }
    }
}

enum ScenarioCategory: String, CaseIterable, Codable {
    case portrait = "Portrait"
    case landscape = "Landscape"
    case fashion = "Fashion"
    case product = "Product"
    case conceptual = "Conceptual"
    
    var icon: String {
        switch self {
        case .portrait:
            return "person.crop.circle"
        case .landscape:
            return "mountain.2"
        case .fashion:
            return "tshirt"
        case .product:
            return "cube.box"
        case .conceptual:
            return "lightbulb"
        }
    }
}

struct FilterOptions: Codable {
    var selectedStatuses: Set<ScenarioStatus> = Set(ScenarioStatus.allCases)
    var selectedCategories: Set<ScenarioCategory> = Set(ScenarioCategory.allCases)
    var locationFilter: String = ""
    var startDate: Date?
    var endDate: Date?
    
    var dateRange: ClosedRange<Date>? {
        get {
            guard let start = startDate, let end = endDate else { return nil }
            return start...end
        }
        set {
            startDate = newValue?.lowerBound
            endDate = newValue?.upperBound
        }
    }
    
    var isActive: Bool {
        return selectedStatuses.count != ScenarioStatus.allCases.count ||
               selectedCategories.count != ScenarioCategory.allCases.count ||
               !locationFilter.isEmpty ||
               dateRange != nil
    }
    
    mutating func reset() {
        selectedStatuses = Set(ScenarioStatus.allCases)
        selectedCategories = Set(ScenarioCategory.allCases)
        locationFilter = ""
        startDate = nil
        endDate = nil
    }
}
