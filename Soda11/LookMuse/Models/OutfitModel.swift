import Foundation
import SwiftUI

struct OutfitID: Identifiable {
    let id: UUID
}

struct OutfitModel: Identifiable, Codable {
    let id = UUID()
    var date: Date
    var description: String
    var location: String
    var weather: String
    var comment: String
    
    var season: Season {
        let month = Calendar.current.component(.month, from: date)
        switch month {
        case 3...5: return .spring
        case 6...8: return .summer
        case 9...11: return .autumn
        default: return .winter
        }
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
    
    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
}

enum Season: String, CaseIterable, Codable {
    case spring = "Spring"
    case summer = "Summer"
    case autumn = "Autumn"
    case winter = "Winter"
    
    var icon: String {
        switch self {
        case .spring: return "leaf"
        case .summer: return "sun.max"
        case .autumn: return "leaf.fill"
        case .winter: return "snowflake"
        }
    }
    
    var color: Color {
        switch self {
        case .spring: return .green
        case .summer: return .yellow
        case .autumn: return .orange
        case .winter: return .blue
        }
    }
}

enum TabItem: String, CaseIterable {
    case outfits = "My Outfits"
    case seasons = "Seasons"
    case notes = "Notes"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .outfits: return "tshirt"
        case .seasons: return "calendar"
        case .notes: return "note.text"
        case .settings: return "gearshape"
        }
    }
}
