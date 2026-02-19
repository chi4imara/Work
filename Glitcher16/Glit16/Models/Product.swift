import Foundation

struct Product: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: String
    var rating: Int
    var expirationDate: Date
    var comment: String
    var dateAdded: Date
    
    init(name: String, category: String, rating: Int, expirationDate: Date, comment: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.rating = rating
        self.expirationDate = expirationDate
        self.comment = comment
        self.dateAdded = Date()
    }
    
    var formattedExpirationDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: expirationDate)
    }
    
    var isExpired: Bool {
        return expirationDate < Date()
    }
    
    var isExpiringSoon: Bool {
        let thirtyDaysFromNow = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
        return expirationDate <= thirtyDaysFromNow && !isExpired
    }
}
