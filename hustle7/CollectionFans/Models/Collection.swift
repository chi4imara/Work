import Foundation
import SwiftUI

enum CollectionCategory: String, CaseIterable, Identifiable, Codable {
    case books = "Books"
    case comics = "Comics"
    case figures = "Figures"
    case stamps = "Stamps"
    case other = "Other"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .books: return "book.fill"
        case .comics: return "photo.artframe"
        case .figures: return "figure.stand"
        case .stamps: return "envelope.fill"
        case .other: return "cube.box.fill"
        }
    }
}

struct Collection: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: CollectionCategory
    var description: String
    var createdAt: Date
    var items: [Item]
    
    init(name: String, category: CollectionCategory = .other, description: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.description = description
        self.createdAt = Date()
        self.items = []
    }
    
    var itemCount: Int {
        items.count
    }
}
