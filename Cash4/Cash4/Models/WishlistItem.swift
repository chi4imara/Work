import Foundation

enum Priority: String, CaseIterable, Codable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

struct WishlistItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var series: String
    var year: Int?
    var targetPrice: Double?
    var priority: Priority
    var notes: String
    var dateAdded: Date
    
    init(name: String = "", series: String = "", year: Int? = nil, targetPrice: Double? = nil, priority: Priority = .medium, notes: String = "") {
        self.name = name
        self.series = series
        self.year = year
        self.targetPrice = targetPrice
        self.priority = priority
        self.notes = notes
        self.dateAdded = Date()
    }
}
