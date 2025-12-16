import Foundation

struct Note: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var createdDate: Date
    
    init(title: String, content: String, createdDate: Date = Date()) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.createdDate = createdDate
    }
    
    init(id: UUID, title: String, content: String, createdDate: Date) {
        self.id = id
        self.title = title
        self.content = content
        self.createdDate = createdDate
    }
    
    var preview: String {
        let maxLength = 100
        if content.count <= maxLength {
            return content
        }
        let index = content.index(content.startIndex, offsetBy: maxLength)
        return String(content[..<index]) + "..."
    }
}
