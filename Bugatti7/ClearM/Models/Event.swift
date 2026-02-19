import Foundation

struct Event: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var date: Date
    var createdAt: Date
    
    init(title: String, date: Date) {
        self.id = UUID()
        self.title = title
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
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}
