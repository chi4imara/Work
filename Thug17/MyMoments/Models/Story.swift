import Foundation

struct Story: Identifiable, Codable, Hashable {
    let id = UUID()
    var title: String
    var content: String
    var tags: [String]
    var createdAt: Date
    var updatedAt: Date
    var viewCount: Int = 0
    var lastViewedAt: Date?
    
    init(title: String, content: String, tags: [String] = []) {
        self.title = title
        self.content = content
        self.tags = tags
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    mutating func updateContent(title: String, content: String, tags: [String]) {
        self.title = title
        self.content = content
        self.tags = tags
        self.updatedAt = Date()
    }
    
    mutating func incrementViewCount() {
        self.viewCount += 1
        self.lastViewedAt = Date()
    }
    
    var preview: String {
        let maxLength = 100
        if content.count <= maxLength {
            return content
        }
        let endIndex = content.index(content.startIndex, offsetBy: maxLength)
        return String(content[..<endIndex]) + "..."
    }
}
