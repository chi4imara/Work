import Foundation
import SwiftUI

struct IdentifiableID<T>: Identifiable {
    let wrappedId: T
    
    var id: UUID {
        if let uuid = wrappedId as? UUID {
            return uuid
        }
        return UUID(uuidString: String(describing: wrappedId)) ?? UUID()
    }
    
    init(_ id: T) {
        self.wrappedId = id
    }
}

struct DayEntry: Identifiable, Codable, Equatable {
    let id: UUID
    let date: Date
    let color: MoodColor
    let description: String
    let createdAt: Date
    let updatedAt: Date
    
    init(date: Date, color: MoodColor, description: String) {
        self.id = UUID()
        self.date = date
        self.color = color
        self.description = description
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    func updated(color: MoodColor? = nil, description: String? = nil) -> DayEntry {
        DayEntry(
            id: self.id,
            date: self.date,
            color: color ?? self.color,
            description: description ?? self.description,
            createdAt: self.createdAt,
            updatedAt: Date()
        )
    }
    
    private init(id: UUID, date: Date, color: MoodColor, description: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.date = date
        self.color = color
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

struct Note: Identifiable, Codable {
    let id: UUID
    let title: String
    let content: String
    let createdAt: Date
    let updatedAt: Date
    
    init(content: String) {
        self.id = UUID()
        self.content = content
        self.title = String(content.prefix(50))
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    func updated(content: String) -> Note {
        Note(
            id: self.id,
            title: String(content.prefix(50)),
            content: content,
            createdAt: self.createdAt,
            updatedAt: Date()
        )
    }
    
    private init(id: UUID, title: String, content: String, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

struct Statistics {
    let totalDays: Int
    let lastSelectedColor: MoodColor?
    let mostFrequentColor: MoodColor?
    let currentStreak: Int
    let lastSevenDays: [MoodColor?]
    
    init(entries: [DayEntry]) {
        self.totalDays = entries.count
        self.lastSelectedColor = entries.first?.color
        
        let colorCounts = Dictionary(grouping: entries, by: { $0.color.name })
            .mapValues { $0.count }
        let mostFrequentColorName = colorCounts.max(by: { $0.value < $1.value })?.key
        self.mostFrequentColor = entries.first { $0.color.name == mostFrequentColorName }?.color
        
        var streak = 0
        let calendar = Calendar.current
        let today = Date()
        
        for i in 0..<entries.count {
            let entryDate = entries[i].date
            let expectedDate = calendar.date(byAdding: .day, value: -i, to: today)!
            
            if calendar.isDate(entryDate, inSameDayAs: expectedDate) {
                streak += 1
            } else {
                break
            }
        }
        self.currentStreak = streak
        
        var lastSeven: [MoodColor?] = []
        for i in 0...6 {
            let targetDate = calendar.date(byAdding: .day, value: -i, to: today)!
            let entry = entries.first { calendar.isDate($0.date, inSameDayAs: targetDate) }
            lastSeven.append(entry?.color)
        }
        self.lastSevenDays = lastSeven
    }
}

struct DailyQuote {
    let text: String
    let author: String?
    
    static let quotes = [
        DailyQuote(text: "Mood is the color of your inner weather.", author: nil),
        DailyQuote(text: "Colors are the smiles of nature.", author: "Leigh Hunt"),
        DailyQuote(text: "Life is about using the whole box of crayons.", author: "RuPaul"),
        DailyQuote(text: "Colors speak louder than words.", author: nil),
        DailyQuote(text: "Every color has a story to tell.", author: nil),
        DailyQuote(text: "Your emotions are valid, just like every color in the spectrum.", author: nil),
        DailyQuote(text: "Paint your day with the colors of your heart.", author: nil),
        DailyQuote(text: "In a world full of black and white, be a rainbow.", author: nil),
        DailyQuote(text: "Colors are the language of emotions.", author: nil),
        DailyQuote(text: "Let your true colors shine through.", author: nil)
    ]
    
    static func todaysQuote() -> DailyQuote {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % quotes.count
        return quotes[index]
    }
}

struct FilterOptions {
    var period: FilterPeriod = .all
    var selectedColors: Set<String> = []
    var searchText: String = ""
    var customStartDate: Date?
    var customEndDate: Date?
}

enum FilterPeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case all = "All"
}
