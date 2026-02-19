import Foundation

struct Decision: Identifiable, Codable, Hashable {
    let id: UUID
    var date: Date
    var situation: String
    var chosenOption: String
    var createdAt: Date
    
    init(date: Date = Date(), situation: String, chosenOption: String) {
        self.id = UUID()
        self.date = date
        self.situation = situation
        self.chosenOption = chosenOption
        self.createdAt = Date()
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    var shortDescription: String {
        return situation.count > 50 ? String(situation.prefix(50)) + "..." : situation
    }
}
