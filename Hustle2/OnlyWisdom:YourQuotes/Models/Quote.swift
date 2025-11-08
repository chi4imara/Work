import Foundation
import SwiftUI

enum QuoteType: String, CaseIterable, Codable {
    case quote = "quote"
    case thought = "thought"
    
    var displayName: String {
        switch self {
        case .quote:
            return "Quote"
        case .thought:
            return "Thought"
        }
    }
    
    var icon: String {
        switch self {
        case .quote:
            return "quote.bubble"
        case .thought:
            return "lightbulb"
        }
    }
}

struct Quote: Identifiable, Codable, Hashable {
    let id = UUID()
    var title: String
    var content: String
    var type: QuoteType
    var source: String?
    var category: String?
    var dateCreated: Date
    var dateArchived: Date?
    var isArchived: Bool
    
    init(title: String, content: String, type: QuoteType, source: String? = nil, category: String? = nil, dateCreated: Date = Date(), isArchived: Bool = false) {
        self.title = title
        self.content = content
        self.type = type
        self.source = source
        self.category = category
        self.dateCreated = dateCreated
        self.isArchived = isArchived
    }
    
    var preview: String {
        let maxLength = 100
        if content.count <= maxLength {
            return content
        }
        return String(content.prefix(maxLength)) + "..."
    }
}

struct Category: Identifiable, Codable, Hashable {
    let id = UUID()
    var name: String
    var dateCreated: Date
    
    init(name: String, dateCreated: Date = Date()) {
        self.name = name
        self.dateCreated = dateCreated
    }
}

enum SortOption: String, CaseIterable {
    case dateCreated = "Date Created"
    case dateArchived = "Date Archived"
    case alphabetical = "Alphabetical"
    case category = "Category"
}

enum FilterPeriod: String, CaseIterable {
    case today = "Today"
    case week = "This Week"
    case month = "This Month"
    case all = "All Time"
    case custom = "Custom Range"
}
