import Foundation

struct Term: Identifiable, Codable {
    let id = UUID()
    var name: String
    var explanation: String
    var dateCreated: Date
    var dateModified: Date
    
    init(name: String, explanation: String, dateCreated: Date = Date(), dateModified: Date = Date()) {
        self.name = name
        self.explanation = explanation
        self.dateCreated = dateCreated
        self.dateModified = dateModified
    }
    
    mutating func update(name: String, explanation: String) {
        self.name = name
        self.explanation = explanation
        self.dateModified = Date()
    }
    
    var shortExplanation: String {
        if explanation.count > 100 {
            return String(explanation.prefix(100)) + "..."
        }
        return explanation
    }
}