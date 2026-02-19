import Foundation

enum WishType: String, CaseIterable, Codable {
    case want = "Want"
    case dontWant = "Don't Want"
    
    var displayName: String {
        return self.rawValue
    }
}

struct WishEntry: Identifiable, Codable {
    let id: UUID
    var type: WishType
    var text: String
    var categoryId: UUID?
    var createdAt: Date
    var updatedAt: Date
    
    init(type: WishType, text: String, categoryId: UUID? = nil) {
        self.id = UUID()
        self.type = type
        self.text = text
        self.categoryId = categoryId
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    mutating func update(type: WishType, text: String, categoryId: UUID? = nil) {
        self.type = type
        self.text = text
        self.categoryId = categoryId
        self.updatedAt = Date()
    }
}
