import Foundation

struct Event: Identifiable, Codable, Equatable {
    let id: UUID
    var text: String
    let timestamp: Date
    
    init(text: String, timestamp: Date = Date()) {
        self.id = UUID()
        self.text = text
        self.timestamp = timestamp
    }
    
    init(id: UUID, text: String, timestamp: Date) {
        self.id = id
        self.text = text
        self.timestamp = timestamp
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = UserDefaults.standard.bool(forKey: "use24HourFormat") ? "HH:mm" : "h:mm a"
        return formatter.string(from: timestamp)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: timestamp)
    }
}
