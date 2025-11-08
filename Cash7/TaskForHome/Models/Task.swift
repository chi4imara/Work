import Foundation

enum TaskFrequency: String, CaseIterable, Codable {
    case daily = "daily"
    case weekly = "weekly"
    
    var displayName: String {
        switch self {
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        }
    }
}

enum WeekDay: String, CaseIterable, Codable {
    case monday = "monday"
    case tuesday = "tuesday"
    case wednesday = "wednesday"
    case thursday = "thursday"
    case friday = "friday"
    case saturday = "saturday"
    case sunday = "sunday"
    
    var displayName: String {
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
    
    var dayNumber: Int {
        switch self {
        case .sunday: return 1
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        }
    }
}

enum Room: String, CaseIterable, Codable {
    case kitchen = "kitchen"
    case bedroom = "bedroom"
    case livingRoom = "living_room"
    case bathroom = "bathroom"
    case hallway = "hallway"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .kitchen: return "Kitchen"
        case .bedroom: return "Bedroom"
        case .livingRoom: return "Living Room"
        case .bathroom: return "Bathroom"
        case .hallway: return "Hallway"
        case .other: return "Other"
        }
    }
}

struct CleaningTask: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var room: Room
    var customRoom: String?
    var frequency: TaskFrequency
    var weekDay: WeekDay?
    var note: String?
    var isCompleted: Bool = false
    var completedDate: Date?
    var isArchived: Bool = false
    var archivedDate: Date?
    var createdDate: Date = Date()
    
    init(title: String, room: Room, customRoom: String? = nil, frequency: TaskFrequency, weekDay: WeekDay? = nil, note: String? = nil, isCompleted: Bool = false, completedDate: Date? = nil, isArchived: Bool = false, archivedDate: Date? = nil, createdDate: Date = Date()) {
        self.id = UUID()
        self.title = title
        self.room = room
        self.customRoom = customRoom
        self.frequency = frequency
        self.weekDay = weekDay
        self.note = note
        self.isCompleted = isCompleted
        self.completedDate = completedDate
        self.isArchived = isArchived
        self.archivedDate = archivedDate
        self.createdDate = createdDate
    }
    
    var displayRoom: String {
        if room == .other, let customRoom = customRoom, !customRoom.isEmpty {
            return customRoom
        }
        return room.displayName
    }
    
    var frequencyDisplay: String {
        switch frequency {
        case .daily:
            return "Daily"
        case .weekly:
            if let weekDay = weekDay {
                return "Weekly: \(weekDay.displayName)"
            }
            return "Weekly"
        }
    }
    
    func isRelevantForToday() -> Bool {
        if isArchived { return false }
        
        switch frequency {
        case .daily:
            return true
        case .weekly:
            guard let weekDay = weekDay else { return false }
            let today = Calendar.current.component(.weekday, from: Date())
            return today == weekDay.dayNumber
        }
    }
}
