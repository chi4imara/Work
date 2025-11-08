import Foundation

struct Trip: Identifiable, Codable {
    let id = UUID()
    var title: String
    var country: String
    var city: String?
    var startDate: Date
    var endDate: Date
    var notes: String
    var places: [String]
    var impressions: [Impression]
    var isArchived: Bool = false
    var createdAt: Date = Date()
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        if Calendar.current.isDate(startDate, inSameDayAs: endDate) {
            return formatter.string(from: startDate)
        } else {
            return "\(formatter.string(from: startDate)) — \(formatter.string(from: endDate))"
        }
    }
    
    var shortNotes: String {
        if notes.count > 100 {
            return String(notes.prefix(100)) + "..."
        }
        return notes
    }
    
    var locationString: String {
        if let city = city, !city.isEmpty {
            return "\(country) • \(city)"
        }
        return country
    }
}

struct Impression: Identifiable, Codable {
    let id = UUID()
    var text: String
    var createdAt: Date = Date()
}

