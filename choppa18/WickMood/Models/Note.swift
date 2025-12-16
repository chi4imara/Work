import Foundation

struct Note: Identifiable, Codable {
    let id = UUID()
    var title: String
    var content: String
    var dateCreated: Date
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
        self.dateCreated = Date()
    }
    
    var preview: String {
        let maxLength = 100
        if content.count <= maxLength {
            return content
        }
        return String(content.prefix(maxLength)) + "..."
    }
}
