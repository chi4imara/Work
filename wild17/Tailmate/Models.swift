import Foundation

enum EventType: String, CaseIterable, Codable {
    case feeding = "feeding"
    case walk = "walk"
    case vitamins = "vitamins"
    case veterinarian = "veterinarian"
    
    var displayName: String {
        switch self {
        case .feeding:
            return "Feeding"
        case .walk:
            return "Walk"
        case .vitamins:
            return "Vitamins"
        case .veterinarian:
            return "Veterinarian"
        }
    }
    
    var iconName: String {
        switch self {
        case .feeding:
            return "fork.knife"
        case .walk:
            return "figure.walk"
        case .vitamins:
            return "pills"
        case .veterinarian:
            return "cross.case"
        }
    }
}

struct PetEvent: Identifiable, Codable {
    var id: UUID
    var type: EventType
    var date: Date
    var time: Date
    var comment: String
    
    init(type: EventType, date: Date = Date(), time: Date = Date(), comment: String = "") {
        self.id = UUID()
        self.type = type
        self.date = date
        self.time = time
        self.comment = comment
    }
    
    var dateTime: Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        var combinedComponents = DateComponents()
        combinedComponents.year = dateComponents.year
        combinedComponents.month = dateComponents.month
        combinedComponents.day = dateComponents.day
        combinedComponents.hour = timeComponents.hour
        combinedComponents.minute = timeComponents.minute
        
        return calendar.date(from: combinedComponents) ?? Date()
    }
}

struct Pet: Codable {
    var name: String
    var species: PetSpecies
    var ageYears: Int
    var ageMonths: Int
    var weight: Double?
    var diet: String
    var vitaminsDescription: String
    var lastVetVisit: Date?
    var veterinarian: String
    var vetComment: String
    
    init() {
        self.name = ""
        self.species = .cat
        self.ageYears = 0
        self.ageMonths = 0
        self.weight = nil
        self.diet = ""
        self.vitaminsDescription = ""
        self.lastVetVisit = nil
        self.veterinarian = ""
        self.vetComment = ""
    }
}

enum PetSpecies: String, CaseIterable, Codable {
    case cat = "cat"
    case dog = "dog"
    
    var displayName: String {
        switch self {
        case .cat:
            return "Cat"
        case .dog:
            return "Dog"
        }
    }
}

struct DayAnalytics {
    let date: Date
    let totalEvents: Int
    let eventTypes: Set<EventType>
    let feedingCount: Int
    let walkCount: Int
    let hasVitamins: Bool
    let hasVeterinarian: Bool
}

struct PeriodAnalytics {
    let totalFeedings: Int
    let totalWalks: Int
    let vitaminDays: Int
    let veterinarianVisits: Int
    let totalActions: Int
    let averageFeedingsPerDay: Double
    let averageWalksPerDay: Double
    let vitaminPercentage: Double
    let topDays: [DayAnalytics]
}

enum TimePeriod: String, CaseIterable, Codable {
    case week = "week"
    case month = "month"
    case allTime = "allTime"
    
    var displayName: String {
        switch self {
        case .week:
            return "Week"
        case .month:
            return "Month"
        case .allTime:
            return "All Time"
        }
    }
}

struct EventFilter: Codable {
    var selectedTypes: Set<EventType>
    var period: TimePeriod
    
    init() {
        self.selectedTypes = Set(EventType.allCases)
        self.period = .month
    }
}
