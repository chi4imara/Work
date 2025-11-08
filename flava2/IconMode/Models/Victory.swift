import Foundation

struct Victory: Identifiable, Codable, Equatable {
    let id: UUID
    var text: String
    var date: Date
    var isFavorite: Bool
    var createdAt: Date
    
    init(text: String, date: Date = Date(), isFavorite: Bool = false) {
        self.id = UUID()
        self.text = text
        self.date = Calendar.current.startOfDay(for: date)
        self.isFavorite = isFavorite
        self.createdAt = Date()
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
    
    var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    var truncatedText: String {
        if text.count > 100 {
            return String(text.prefix(100)) + "..."
        }
        return text
    }
}

extension Victory {
    static func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    
    func isSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self.date, inSameDayAs: date)
    }
}

extension Victory {
    static let sampleVictories: [Victory] = [
        Victory(text: "Completed my morning workout routine", date: Date(), isFavorite: true),
        Victory(text: "Finished reading a chapter of my book", date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()),
        Victory(text: "Cooked a healthy meal instead of ordering takeout", date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), isFavorite: true),
        Victory(text: "Had a productive meeting with my team", date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()),
        Victory(text: "Learned a new SwiftUI technique", date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date())
    ]
}
