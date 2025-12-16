import Foundation

struct Note: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var dateCreated: Date
    var dateModified: Date
    
    init(title: String, content: String) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.dateCreated = Date()
        self.dateModified = Date()
    }
    
    mutating func updateModifiedDate() {
        self.dateModified = Date()
    }
    
    var previewText: String {
        let maxLength = 100
        if content.count <= maxLength {
            return content
        }
        let index = content.index(content.startIndex, offsetBy: maxLength)
        return String(content[..<index]) + "..."
    }
}
