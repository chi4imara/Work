import Foundation
import SwiftUI

enum ToolCategory: String, CaseIterable, Identifiable, Codable {
    case brushes = "Brushes"
    case sponges = "Sponges"
    case curlers = "Curlers"
    case tweezers = "Tweezers"
    case other = "Other"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .brushes: return "Brushes"
        case .sponges: return "Sponges"
        case .curlers: return "Curlers"
        case .tweezers: return "Tweezers"
        case .other: return "Other"
        }
    }
}

enum ToolCondition: String, CaseIterable, Identifiable, Codable {
    case good = "Good"
    case worn = "Worn"
    case needsReplacement = "Needs Replacement"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .good: return "Good condition"
        case .worn: return "Worn"
        case .needsReplacement: return "Needs replacement"
        }
    }
    
    var color: Color {
        switch self {
        case .good: return .green
        case .worn: return .yellow
        case .needsReplacement: return .red
        }
    }
}

struct Tool: Identifiable, Codable {
    let id: UUID
    var name: String
    var category: ToolCategory
    var purchaseDate: Date
    var condition: ToolCondition
    var comment: String
    
    init(name: String, category: ToolCategory, purchaseDate: Date, condition: ToolCondition, comment: String = "") {
        self.id = UUID()
        self.name = name
        self.category = category
        self.purchaseDate = purchaseDate
        self.condition = condition
        self.comment = comment
    }
    
    init(id: UUID, name: String, category: ToolCategory, purchaseDate: Date, condition: ToolCondition, comment: String = "") {
        self.id = id
        self.name = name
        self.category = category
        self.purchaseDate = purchaseDate
        self.condition = condition
        self.comment = comment
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case purchaseDate
        case condition
        case comment
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(ToolCategory.self, forKey: .category)
        purchaseDate = try container.decode(Date.self, forKey: .purchaseDate)
        condition = try container.decode(ToolCondition.self, forKey: .condition)
        comment = try container.decode(String.self, forKey: .comment)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(category, forKey: .category)
        try container.encode(purchaseDate, forKey: .purchaseDate)
        try container.encode(condition, forKey: .condition)
        try container.encode(comment, forKey: .comment)
    }
    
    var isOld: Bool {
        let calendar = Calendar.current
        let monthsAgo = calendar.dateInterval(of: .month, for: Date())?.start ?? Date()
        let twelveMonthsAgo = calendar.date(byAdding: .month, value: -12, to: monthsAgo) ?? Date()
        return purchaseDate < twelveMonthsAgo
    }
    
    var actualCondition: ToolCondition {
        if isOld && condition != .needsReplacement {
            return .needsReplacement
        }
        return condition
    }
}
