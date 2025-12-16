import Foundation

struct DailyMoment: Identifiable, Codable, Equatable {
    let id: UUID
    var text: String
    var date: Date
    var createdAt: Date
    var updatedAt: Date?
    
    init(text: String, date: Date = Date()) {
        self.id = UUID()
        self.text = text
        self.date = date
        self.createdAt = date
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: createdAt)
    }
    
    var shortText: String {
        if text.count > 100 {
            return String(text.prefix(100)) + "..."
        }
        return text
    }
}

struct Note: Identifiable, Codable, Equatable {
    let id: UUID
    var text: String
    var createdAt: Date
    var updatedAt: Date?
    
    init(text: String) {
        self.id = UUID()
        self.text = text
        self.createdAt = Date()
    }
    
    var title: String {
        let lines = text.components(separatedBy: .newlines)
        return lines.first?.isEmpty == false ? lines.first! : "Untitled Note"
    }
    
    var shortText: String {
        let lines = text.components(separatedBy: .newlines)
        let bodyLines = lines.dropFirst()
        let bodyText = bodyLines.joined(separator: " ")
        
        if bodyText.count > 80 {
            return String(bodyText.prefix(80)) + "..."
        }
        return bodyText
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: createdAt)
    }
}

enum AppState {
    case onboarding
    case main
}

enum TabItem: String, CaseIterable {
    case home = "Home"
    case history = "History"
    case notes = "Notes"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var iconName: String {
        switch self {
        case .home:
            return "house"
        case .history:
            return "clock"
        case .notes:
            return "note.text"
        case .statistics:
            return "chart.bar"
        case .settings:
            return "gearshape"
        }
    }
}

struct UserStatistics {
    var totalDaysWithEntries: Int
    var lastMomentDate: Date?
    var currentStreak: Int
    var averageEntryTime: String
    
    init() {
        self.totalDaysWithEntries = 0
        self.lastMomentDate = nil
        self.currentStreak = 0
        self.averageEntryTime = "00:00"
    }
}

struct DailyQuote: Codable {
    let text: String
    let author: String?
    
    static let quotes = [
        DailyQuote(text: "Life is made of small moments like this.", author: nil),
        DailyQuote(text: "The present moment is the only time over which we have dominion.", author: "Thích Nhất Hạnh"),
        DailyQuote(text: "Yesterday is history, tomorrow is a mystery, today is a gift.", author: nil),
        DailyQuote(text: "Life is what happens when you're busy making other plans.", author: "John Lennon"),
        DailyQuote(text: "The little things? The little moments? They aren't little.", author: "Jon Kabat-Zinn"),
        DailyQuote(text: "Enjoy the little things in life, for one day you may look back and realize they were the big things.", author: "Robert Brault"),
        DailyQuote(text: "Life is a series of thousands of tiny miracles. Notice them.", author: nil),
        DailyQuote(text: "The best way to take care of the future is to take care of the present moment.", author: "Thích Nhất Hạnh"),
        DailyQuote(text: "Life isn't measured by the number of breaths you take, but by the moments that take your breath away.", author: nil),
        DailyQuote(text: "Sometimes the smallest step in the right direction ends up being the biggest step of your life.", author: nil)
    ]
    
    static func randomQuote() -> DailyQuote {
        return quotes.randomElement() ?? quotes[0]
    }
}

enum ModalType: Identifiable {
    case createMoment
    case editMoment(UUID)
    case createNote
    case editNote(UUID)
    case momentDetail(UUID)
    case noteDetail(UUID)
    
    var id: String {
        switch self {
        case .createMoment:
            return "createMoment"
        case .editMoment(let id):
            return "editMoment_\(id.uuidString)"
        case .createNote:
            return "createNote"
        case .editNote(let id):
            return "editNote_\(id.uuidString)"
        case .momentDetail(let id):
            return "momentDetail_\(id.uuidString)"
        case .noteDetail(let id):
            return "noteDetail_\(id.uuidString)"
        }
    }
}
