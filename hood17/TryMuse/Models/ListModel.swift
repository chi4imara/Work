import Foundation

struct ListModel: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: ListCategory
    var createdAt: Date
    var updatedAt: Date
    
    init(name: String, category: ListCategory) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

enum ListCategory: String, CaseIterable, Codable {
    case movies = "Movies"
    case books = "Books"
    case food = "Food"
    case ideas = "Ideas"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
}
