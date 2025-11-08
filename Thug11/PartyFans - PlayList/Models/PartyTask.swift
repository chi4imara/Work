import Foundation

struct PartyTask: Identifiable, Codable {
    let id: UUID
    var text: String
    var category: String
    var dateCreated: Date
    
    init(id: UUID = UUID(), text: String, category: String, dateCreated: Date = Date()) {
        self.id = id
        self.text = text
        self.category = category
        self.dateCreated = dateCreated
    }
}
