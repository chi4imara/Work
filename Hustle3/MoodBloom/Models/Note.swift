import Foundation

struct Note: Identifiable, Codable, Hashable {
    let id = UUID()
    var title: String
    var content: String
    let createdAt: Date
    var updatedAt: Date
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    var preview: String {
        String(content.prefix(100))
    }
    
    mutating func update(title: String, content: String) {
        self.title = title
        self.content = content
        self.updatedAt = Date()
    }
}
