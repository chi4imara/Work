import Foundation

struct Smile: Identifiable, Codable {
    let id: UUID
    var text: String
    var createdAt: Date
    
    init(text: String, createdAt: Date = Date()) {
        self.id = UUID()
        self.text = text
        self.createdAt = createdAt
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: createdAt)
    }
    
    var shortText: String {
        let lines = text.components(separatedBy: .newlines)
        let firstTwoLines = Array(lines.prefix(2)).joined(separator: "\n")
        return firstTwoLines.count > 100 ? String(firstTwoLines.prefix(100)) + "..." : firstTwoLines
    }
}

struct Thought: Identifiable, Codable {
    let id: UUID
    var text: String
    var createdAt: Date
    var updatedAt: Date?
    
    init(text: String, createdAt: Date = Date()) {
        self.id = UUID()
        self.text = text
        self.createdAt = createdAt
    }
    
    var title: String {
        let firstLine = text.components(separatedBy: .newlines).first ?? ""
        return firstLine.isEmpty ? "Untitled" : firstLine
    }
    
    var preview: String {
        let lines = text.components(separatedBy: .newlines)
        let previewLines = Array(lines.prefix(2)).joined(separator: "\n")
        return previewLines.count > 150 ? String(previewLines.prefix(150)) + "..." : previewLines
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: createdAt)
    }
    
    var isEdited: Bool {
        return updatedAt != nil
    }
}

struct SmileStatistics {
    let totalSmiles: Int
    let lastSmileDate: Date?
    let maxSmilesInDay: Int
    let daysWithSmiles: Int
    
    var lastSmileDateString: String {
        guard let date = lastSmileDate else { return "Never" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct DailyQuote {
    let text: String
    let date: Date
    
    static let quotes = [
        "Sometimes a smile is the best thank you to the world.",
        "A smile is the shortest distance between two people.",
        "Smiles are contagious, spread them everywhere.",
        "Every smile makes you a day younger.",
        "A smile is happiness you'll find right under your nose.",
        "Smile, it's free therapy.",
        "A smile is the prettiest thing you can wear.",
        "Keep smiling, because life is a beautiful thing.",
        "Smile and let everyone know that today you're stronger.",
        "A warm smile is the universal language of kindness."
    ]
    
    static func todaysQuote() -> DailyQuote {
        let today = Calendar.current.startOfDay(for: Date())
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: today) ?? 1
        let quoteIndex = (dayOfYear - 1) % quotes.count
        return DailyQuote(text: quotes[quoteIndex], date: today)
    }
}

struct SmileFilter {
    enum Period: CaseIterable {
        case today, week, month, all
        
        var title: String {
            switch self {
            case .today: return "Today"
            case .week: return "Week"
            case .month: return "Month"
            case .all: return "All"
            }
        }
    }
    
    var period: Period = .all
    var searchText: String = ""
    var customStartDate: Date?
    var customEndDate: Date?
    
    func matches(_ smile: Smile) -> Bool {
        if !searchText.isEmpty && !smile.text.localizedCaseInsensitiveContains(searchText) {
            return false
        }
        
        let calendar = Calendar.current
        let now = Date()
        
        switch period {
        case .today:
            return calendar.isDate(smile.createdAt, inSameDayAs: now)
        case .week:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            return smile.createdAt >= weekAgo
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return smile.createdAt >= monthAgo
        case .all:
            return true
        }
    }
}

