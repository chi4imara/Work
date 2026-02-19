import Foundation
import SwiftUI

enum Mood: String, CaseIterable, Codable {
    case happy = "Happy"
    case neutral = "Neutral" 
    case sad = "Sad"
    case cool = "Cool"
    
    var icon: String {
        switch self {
        case .happy:
            return "face.smiling"
        case .neutral:
            return "face.dashed"
        case .sad:
            return "face.dashed.fill"
        case .cool:
            return "sunglasses"
        }
    }
    
    var color: Color {
        switch self {
        case .happy:
            return ColorManager.successGreen
        case .neutral:
            return ColorManager.neutralGray
        case .sad:
            return ColorManager.warningRed
        case .cool:
            return ColorManager.primaryText
        }
    }
}

enum Reaction: String, CaseIterable, Codable {
    case positive = "Positive"
    case neutral = "Neutral"
    case negative = "Negative"
    case unnoticed = "Unnoticed"
    
    var color: Color {
        switch self {
        case .positive:
            return ColorManager.successGreen
        case .neutral:
            return ColorManager.neutralGray
        case .negative:
            return ColorManager.warningRed
        case .unnoticed:
            return ColorManager.secondaryText
        }
    }
}
struct Tag: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var usageCount: Int = 0
    
    init(name: String) {
        self.id = UUID()
        self.name = name
    }
}

struct OutfitEntry: Identifiable, Codable {
    let id: UUID
    var date: Date
    var description: String
    var comfort: Int
    var mood: Mood
    var reaction: Reaction
    var notes: String
    var tags: [String]
    
    init(date: Date = Date(), 
         description: String = "", 
         comfort: Int = 5, 
         mood: Mood = .neutral, 
         reaction: Reaction = .neutral, 
         notes: String = "", 
         tags: [String] = []) {
        self.id = UUID()
        self.date = date
        self.description = description
        self.comfort = comfort
        self.mood = mood
        self.reaction = reaction
        self.notes = notes
        self.tags = tags
    }
    
    var shortDescription: String {
        let words = description.components(separatedBy: " ")
        if words.count > 10 {
            return words.prefix(10).joined(separator: " ") + "..."
        }
        return description
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

