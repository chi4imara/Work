import Foundation
import SwiftUI

enum ItemStatus: String, CaseIterable, Identifiable, Codable {
    case inCollection = "In Collection"
    case wishlist = "Wishlist"
    case forTrade = "For Trade"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .inCollection: return "checkmark.circle.fill"
        case .wishlist: return "star.fill"
        case .forTrade: return "arrow.2.circlepath"
        }
    }
}

enum ItemCondition: String, CaseIterable, Identifiable, Codable {
    case excellent = "Excellent"
    case good = "Good"
    case fair = "Fair"
    case poor = "Poor"
    
    var id: String { self.rawValue }
}

struct Item: Identifiable, Codable {
    let id: UUID
    var name: String
    var status: ItemStatus
    var description: String
    var condition: ItemCondition?
    var notes: String
    var isFavorite: Bool
    var addedAt: Date
    
    init(name: String, status: ItemStatus = .inCollection, description: String = "", condition: ItemCondition? = nil, notes: String = "", isFavorite: Bool = false) {
        self.id = UUID()
        self.name = name
        self.status = status
        self.description = description
        self.condition = condition
        self.notes = notes
        self.isFavorite = isFavorite
        self.addedAt = Date()
    }
}
