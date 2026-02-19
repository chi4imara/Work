import Foundation

struct Project: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: String
    var startDate: Date
    var comment: String
    var result: String
    
    init(name: String, category: String, startDate: Date, comment: String = "", result: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.startDate = startDate
        self.comment = comment
        self.result = result
    }
}
