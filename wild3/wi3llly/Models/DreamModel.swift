import Foundation

struct DreamModel: Codable, Identifiable, Equatable {
    let id: UUID
    var title: String
    var content: String
    var tags: [String]
    let createdAt: Date
    var updatedAt: Date
    
    init(title: String, content: String, tags: [String] = []) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.tags = tags
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    mutating func update(title: String, content: String, tags: [String]) {
        self.title = title
        self.content = content
        self.tags = tags
        self.updatedAt = Date()
    }
}

struct TagModel: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let createdAt: Date
    
    private static let maxTagLength = 20
    
    init(name: String) {
        self.id = UUID()
        let trimmed = name.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        self.name = trimmed.count > Self.maxTagLength ? String(trimmed.prefix(Self.maxTagLength)) : trimmed
        self.createdAt = Date()
    }
}
