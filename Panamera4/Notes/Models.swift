import Foundation
import SwiftUI

struct HairCareProcedure: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: ProcedureCategory
    var date: Date
    var effect: String
    var description: String
    
    init(name: String, category: ProcedureCategory, date: Date = Date(), effect: String = "", description: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.date = date
        self.effect = effect
        self.description = description
    }
}

enum ProcedureCategory: String, CaseIterable, Codable {
    case washing = "Washing"
    case masks = "Masks"
    case oils = "Oils"
    case serums = "Serums"
    case styling = "Styling"
    case other = "Other"
    
    var displayName: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .washing:
            return "drop.fill"
        case .masks:
            return "face.smiling"
        case .oils:
            return "drop.circle"
        case .serums:
            return "eyedropper"
        case .styling:
            return "wand.and.stars"
        case .other:
            return "ellipsis.circle"
        }
    }
}

struct CategoryStatistics {
    let category: ProcedureCategory
    let count: Int
    
    var displayText: String {
        return "\(category.displayName) — \(count) times"
    }
}
