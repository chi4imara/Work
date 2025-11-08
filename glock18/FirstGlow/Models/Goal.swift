import Foundation

struct Goal: Identifiable, Codable {
    var id: UUID
    var title: String
    var description: String
    var createdAt: Date
    var isCompleted: Bool
    var completedAt: Date?
    
    init(title: String, description: String) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.createdAt = Date()
        self.isCompleted = false
        self.completedAt = nil
    }
}
