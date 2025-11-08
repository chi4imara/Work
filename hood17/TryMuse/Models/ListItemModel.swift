import Foundation

struct ListItemModel: Identifiable, Codable {
    let id: UUID
    var name: String
    var notes: String
    var isCompleted: Bool
    var listId: UUID
    var createdAt: Date
    var updatedAt: Date
    var completedAt: Date?
    
    init(name: String, notes: String = "", listId: UUID) {
        self.id = UUID()
        self.name = name
        self.notes = notes
        self.isCompleted = false
        self.listId = listId
        self.createdAt = Date()
        self.updatedAt = Date()
        self.completedAt = nil
    }
}
