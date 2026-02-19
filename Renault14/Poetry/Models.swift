import SwiftUI
import Foundation

struct WardrobeItem: Identifiable, Codable {
    var id: UUID
    var name: String
    var category: String
    var color: String
    var size: String?
    var imageName: String?
    var comment: String?
    var dateAdded: Date
    
    init(id: UUID = UUID(), name: String, category: String, color: String, size: String? = nil, imageName: String? = nil, comment: String? = nil, dateAdded: Date = Date()) {
        self.id = id
        self.name = name
        self.category = category
        self.color = color
        self.size = size
        self.imageName = imageName
        self.comment = comment
        self.dateAdded = dateAdded
    }
}

struct Category: Identifiable, Codable {
    var id: UUID
    var name: String
    var isRepeating: Bool
    var dateCreated: Date
    
    init(id: UUID = UUID(), name: String, isRepeating: Bool = true, dateCreated: Date = Date()) {
        self.id = id
        self.name = name
        self.isRepeating = isRepeating
        self.dateCreated = dateCreated
    }
}

struct Outfit: Identifiable, Codable {
    var id: UUID
    var name: String
    var items: [WardrobeItem]
    var imageName: String?
    var dateCreated: Date
    var category: String?
    
    init(id: UUID = UUID(), name: String, items: [WardrobeItem] = [], imageName: String? = nil, category: String? = nil, dateCreated: Date = Date()) {
        self.id = id
        self.name = name
        self.items = items
        self.imageName = imageName
        self.category = category
        self.dateCreated = dateCreated
    }
}

extension Category {
    static let defaultCategories = [
        Category(name: "Outerwear"),
        Category(name: "Shoes"),
        Category(name: "Accessories"),
        Category(name: "Dresses"),
        Category(name: "Blouses")
    ]
}
