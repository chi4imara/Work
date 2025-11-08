import Foundation

struct Idea: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var category: String
    var dateAdded: Date
    var note: String
    
    init(title: String, category: String, dateAdded: Date = Date(), note: String = "") {
        self.id = UUID()
        self.title = title
        self.category = category
        self.dateAdded = dateAdded
        self.note = note
    }
}

extension Idea {
    static let defaultCategories = [
        "Quiet Leisure",
        "Games", 
        "Creativity",
        "Cooking",
        "Sports"
    ]
    
    static let sampleIdeas = [
        Idea(title: "Read a book", category: "Quiet Leisure", note: "30 minutes of novel reading"),
        Idea(title: "Play board game", category: "Games", note: "Chess or checkers"),
        Idea(title: "Draw something", category: "Creativity", note: "Sketch in notebook"),
        Idea(title: "Cook new recipe", category: "Cooking", note: "Try pasta dish"),
        Idea(title: "Home workout", category: "Sports", note: "15 minutes exercise")
    ]
}
