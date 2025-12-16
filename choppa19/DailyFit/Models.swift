import Foundation

struct Outfit: Identifiable, Codable {
    let id: UUID
    var name: String
    var season: Season
    var mood: Mood
    var situation: Situation
    var comment: String
    var isFavorite: Bool
    var dateCreated: Date
    
    init(name: String, season: Season, mood: Mood, situation: Situation, comment: String = "", isFavorite: Bool = false) {
        self.id = UUID()
        self.name = name
        self.season = season
        self.mood = mood
        self.situation = situation
        self.comment = comment
        self.isFavorite = isFavorite
        self.dateCreated = Date()
    }
}

enum Season: String, CaseIterable, Codable {
    case spring = "Spring"
    case summer = "Summer"
    case autumn = "Autumn"
    case winter = "Winter"
    
    var displayName: String {
        return self.rawValue
    }
}

enum Mood: String, CaseIterable, Codable {
    case casual = "Casual"
    case business = "Business"
    case romantic = "Romantic"
    case cozy = "Cozy"
    
    var displayName: String {
        return self.rawValue
    }
}

enum Situation: String, CaseIterable, Codable {
    case work = "Work"
    case walk = "Walk"
    case evening = "Evening"
    case meeting = "Meeting"
    
    var displayName: String {
        return self.rawValue
    }
}

struct Note: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var dateCreated: Date
    var dateModified: Date
    
    init(title: String, content: String) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.dateCreated = Date()
        self.dateModified = Date()
    }
    
    mutating func update(title: String, content: String) {
        self.title = title
        self.content = content
        self.dateModified = Date()
    }
    
    var preview: String {
        let maxLength = 100
        if content.count <= maxLength {
            return content
        }
        let index = content.index(content.startIndex, offsetBy: maxLength)
        return String(content[..<index]) + "..."
    }
}

struct WeekPlan: Codable {
    var monday: UUID?
    var tuesday: UUID?
    var wednesday: UUID?
    var thursday: UUID?
    var friday: UUID?
    var saturday: UUID?
    var sunday: UUID?
    
    init() {
        self.monday = nil
        self.tuesday = nil
        self.wednesday = nil
        self.thursday = nil
        self.friday = nil
        self.saturday = nil
        self.sunday = nil
    }
    
    mutating func setOutfit(for day: WeekDay, outfitId: UUID?) {
        switch day {
        case .monday:
            monday = outfitId
        case .tuesday:
            tuesday = outfitId
        case .wednesday:
            wednesday = outfitId
        case .thursday:
            thursday = outfitId
        case .friday:
            friday = outfitId
        case .saturday:
            saturday = outfitId
        case .sunday:
            sunday = outfitId
        }
    }
    
    func getOutfit(for day: WeekDay) -> UUID? {
        switch day {
        case .monday:
            return monday
        case .tuesday:
            return tuesday
        case .wednesday:
            return wednesday
        case .thursday:
            return thursday
        case .friday:
            return friday
        case .saturday:
            return saturday
        case .sunday:
            return sunday
        }
    }
    
    mutating func clearAll() {
        monday = nil
        tuesday = nil
        wednesday = nil
        thursday = nil
        friday = nil
        saturday = nil
        sunday = nil
    }
}

enum WeekDay: String, CaseIterable, Identifiable {
    case monday = "Mon"
    case tuesday = "Tue"
    case wednesday = "Wed"
    case thursday = "Thu"
    case friday = "Fri"
    case saturday = "Sat"
    case sunday = "Sun"
    
    var id: String { rawValue }
    
    var fullName: String {
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
}

enum OutfitFilter: String, CaseIterable {
    case all = "All"
    case favorites = "Favorites"
    case season = "Season"
    case mood = "Mood"
    
    var displayName: String {
        return self.rawValue
    }
}
