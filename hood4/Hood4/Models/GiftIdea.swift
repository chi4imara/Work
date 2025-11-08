import Foundation

struct GiftIdea: Identifiable, Codable {
    let id: UUID
    var personId: UUID
    var title: String
    var status: GiftStatus
    var eventType: EventType?
    var eventDate: Date?
    var budget: Double?
    var store: String?
    var notes: String?
    var createdAt: Date
    
    init(personId: UUID, title: String, status: GiftStatus = .idea) {
        self.id = UUID()
        self.personId = personId
        self.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        self.status = status
        self.createdAt = Date()
    }
    
    var formattedBudget: String? {
        guard let budget = budget else { return nil }
        return String(format: "$%.2f", budget)
    }
    
    var isValidBudget: Bool {
        guard let budget = budget else { return true }
        return budget > 0
    }
}
