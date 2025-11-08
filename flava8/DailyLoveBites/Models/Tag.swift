import Foundation

struct Tag: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    let createdAt: Date
    
    init(name: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Date()
    }
    
    var displayName: String {
        return "#\(name)"
    }
    
    static func isValidTagName(_ name: String) -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && trimmed.count <= 24
    }
}
