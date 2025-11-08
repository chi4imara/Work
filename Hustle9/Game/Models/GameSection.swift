import Foundation

struct GameSection: Identifiable, Codable {
    let id = UUID()
    var title: String
    var content: String
    var dateCreated: Date
    var dateModified: Date
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
        self.dateCreated = Date()
        self.dateModified = Date()
    }
    
    var preview: String {
        let maxLength = 100
        if content.count <= maxLength {
            return content
        }
        let endIndex = content.index(content.startIndex, offsetBy: maxLength)
        return String(content[..<endIndex]) + "..."
    }
    
    mutating func updateContent(_ newContent: String) {
        self.content = newContent
        self.dateModified = Date()
    }
    
    mutating func updateTitle(_ newTitle: String) {
        self.title = newTitle
        self.dateModified = Date()
    }
}
