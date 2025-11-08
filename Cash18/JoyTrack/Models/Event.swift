import Foundation

enum EventType: String, CaseIterable, Codable {
    case birthday = "birthday"
    case anniversary = "anniversary"
    case holiday = "holiday"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .birthday:
            return "Birthday"
        case .anniversary:
            return "Anniversary"
        case .holiday:
            return "Unusual Holiday"
        case .other:
            return "Other"
        }
    }
    
    var icon: String {
        switch self {
        case .birthday:
            return "gift.fill"
        case .anniversary:
            return "heart.fill"
        case .holiday:
            return "star.fill"
        case .other:
            return "calendar"
        }
    }
}

struct Event: Identifiable, Codable, Equatable {
    let id = UUID()
    var title: String
    var type: EventType
    var date: Date
    var note: String
    var giftIdeas: [String]
    var isFavorite: Bool
    var isActive: Bool
    
    init(title: String, type: EventType, date: Date, note: String = "", giftIdeas: [String] = [], isFavorite: Bool = false, isActive: Bool = true) {
        self.title = title
        self.type = type
        self.date = date
        self.note = note
        self.giftIdeas = giftIdeas
        self.isFavorite = isFavorite
        self.isActive = isActive
    }
    
    var shortNote: String {
        if note.count > 50 {
            return String(note.prefix(50)) + "..."
        }
        return note
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    var daysUntil: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
    }
}
