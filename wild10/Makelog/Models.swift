import Foundation

struct WeatherEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var description: String
    var category: WeatherCategory
    var date: Date
    var createdAt: Date
    
    init(description: String, category: WeatherCategory, date: Date = Date()) {
        self.id = UUID()
        self.description = description
        self.category = category
        self.date = date
        self.createdAt = Date()
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    var shortFormattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    var truncatedDescription: String {
        let words = description.components(separatedBy: .whitespacesAndNewlines)
        let maxWords = 20
        if words.count > maxWords {
            return words.prefix(maxWords).joined(separator: " ") + "..."
        }
        return description
    }
}

struct WeatherCategory: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var color: String
    
    init(name: String, color: String = "#6B46C1") {
        self.id = UUID()
        self.name = name
        self.color = color
    }
    
    static let sunny = WeatherCategory(name: "Sunny", color: "#F59E0B")
    static let rainy = WeatherCategory(name: "Rainy", color: "#3B82F6")
    static let cloudy = WeatherCategory(name: "Cloudy", color: "#6B7280")
    static let snowy = WeatherCategory(name: "Snowy", color: "#E5E7EB")
    static let stormy = WeatherCategory(name: "Stormy", color: "#7C3AED")
    static let windy = WeatherCategory(name: "Windy", color: "#10B981")
    
    static let defaultCategories: [WeatherCategory] = [
        .sunny, .rainy, .cloudy, .snowy, .stormy, .windy
    ]
}

enum SortOption: String, CaseIterable {
    case dateDescending = "Date (Newest First)"
    case dateAscending = "Date (Oldest First)"
    case alphabetical = "Alphabetical"
    
    var displayName: String {
        return self.rawValue
    }
}

struct FilterState {
    var selectedCategory: WeatherCategory?
    var sortOption: SortOption = .dateDescending
    var isActive: Bool {
        return selectedCategory != nil
    }
}

enum AppState {
    case splash
    case onboarding
    case main
}
