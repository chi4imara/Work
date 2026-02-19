import Foundation

struct Principle: Identifiable, Codable, Equatable {
    let id: UUID
    var text: String
    let createdAt: Date
    var updatedAt: Date
    
    init(text: String) {
        self.id = UUID()
        self.text = text
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    mutating func updateText(_ newText: String) {
        self.text = newText
        self.updatedAt = Date()
    }
    
    var displayText: String {
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var shortDisplayText: String {
        let maxLength = 100
        if displayText.count <= maxLength {
            return displayText
        }
        return String(displayText.prefix(maxLength)) + "..."
    }
}