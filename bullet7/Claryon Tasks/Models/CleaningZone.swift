import Foundation

struct CleaningZone: Identifiable, Codable {
    let id = UUID()
    var name: String
    var category: String
    var description: String
    var isCompleted: Bool = false
    var lastCleanedDate: Date?
    var createdDate: Date = Date()
    
    var formattedLastCleanedDate: String {
        guard let lastCleanedDate = lastCleanedDate else {
            return "Not cleaned"
        }
        
        let calendar = Calendar.current
        if calendar.isDateInToday(lastCleanedDate) {
            return "Cleaned today"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return "Cleaned \(formatter.string(from: lastCleanedDate))"
        }
    }
}
