import Foundation

struct Note: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var createdDate: Date
    
    init(title: String, content: String) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.createdDate = Date()
    }
    
    var preview: String {
        if content.count > Constants.Limits.maxNotePreviewLength {
            return String(content.prefix(Constants.Limits.maxNotePreviewLength)) + "..."
        }
        return content
    }
}
