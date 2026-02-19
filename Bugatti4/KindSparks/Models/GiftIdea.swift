import Foundation

struct GiftIdea: Identifiable, Codable {
    let id = UUID()
    var text: String
    var personId: UUID
    var createdAt: Date
    
    init(text: String, personId: UUID, createdAt: Date = Date()) {
        self.text = text
        self.personId = personId
        self.createdAt = createdAt
    }
}