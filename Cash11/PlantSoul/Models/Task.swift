import Foundation

struct Task: Identifiable, Codable, Equatable {
    let id = UUID()
    var plantId: UUID
    var plantName: String
    var type: TaskType
    var date: Date
    var time: Date?
    var description: String
    var requiredItems: [String]
    var steps: [TaskStep]
    var isCompleted: Bool
    var isFavorite: Bool
    var isArchived: Bool
    var completedDate: Date?
    
    init(plantId: UUID, plantName: String, type: TaskType, date: Date, time: Date? = nil, description: String = "", requiredItems: [String] = [], steps: [TaskStep] = []) {
        self.plantId = plantId
        self.plantName = plantName
        self.type = type
        self.date = date
        self.time = time
        self.description = description
        self.requiredItems = requiredItems
        self.steps = steps
        self.isCompleted = false
        self.isFavorite = false
        self.isArchived = false
        self.completedDate = nil
    }
}

enum TaskType: String, CaseIterable, Codable {
    case watering = "Watering"
    case fertilizing = "Fertilizing"
    case repotting = "Repotting"
    case cleaning = "Cleaning"
    case generalCare = "General Care"
    
    var icon: String {
        switch self {
        case .watering:
            return "drop.fill"
        case .fertilizing:
            return "leaf.fill"
        case .repotting:
            return "leaf.circle.fill"
        case .cleaning:
            return "sparkles"
        case .generalCare:
            return "heart.fill"
        }
    }
    
    var color: String {
        switch self {
        case .watering:
            return "lightBlue"
        case .fertilizing:
            return "softGreen"
        case .repotting:
            return "warmYellow"
        case .cleaning:
            return "lightBlue"
        case .generalCare:
            return "softGreen"
        }
    }
}

struct TaskStep: Identifiable, Codable, Equatable {
    let id = UUID()
    var title: String
    var description: String
    var isCompleted: Bool
    
    init(title: String, description: String = "") {
        self.title = title
        self.description = description
        self.isCompleted = false
    }
}

