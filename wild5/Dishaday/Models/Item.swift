import Foundation

struct Item: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: String
    var story: String
    var datePeriod: String?
    var dateAdded: Date
    
    init(name: String, category: String, story: String, datePeriod: String? = nil) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.story = story
        self.datePeriod = datePeriod
        self.dateAdded = Date()
    }
}

extension Item {
    var storyPreview: String {
        let lines = story.components(separatedBy: .newlines)
        let firstTwoLines = Array(lines.prefix(2))
        return firstTwoLines.joined(separator: "\n")
    }
    
    var storyThreeLines: String {
        let lines = story.components(separatedBy: .newlines)
        let firstThreeLines = Array(lines.prefix(3))
        return firstThreeLines.joined(separator: "\n")
    }
}
