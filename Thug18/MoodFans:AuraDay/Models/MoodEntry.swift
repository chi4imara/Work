import Foundation
import SwiftUI

struct MoodEntry: Codable, Identifiable {
    let id = UUID()
    let date: Date
    let moodColor: MoodColor
    let note: String
    let createdAt: Date
    var updatedAt: Date
    var isFavorite: Bool
    
    init(date: Date, moodColor: MoodColor, note: String = "", isFavorite: Bool = false) {
        self.date = date
        self.moodColor = moodColor
        self.note = note
        self.createdAt = Date()
        self.updatedAt = Date()
        self.isFavorite = isFavorite
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }
}

enum MoodColor: String, CaseIterable, Codable {
    case red = "red"
    case orange = "orange"
    case yellow = "yellow"
    case green = "green"
    case blue = "blue"
    case purple = "purple"
    case gray = "gray"
    case white = "white"
    
    var displayName: String {
        switch self {
        case .red: return "Red"
        case .orange: return "Orange"
        case .yellow: return "Yellow"
        case .green: return "Green"
        case .blue: return "Blue"
        case .purple: return "Purple"
        case .gray: return "Gray"
        case .white: return "White"
        }
    }
    
    var emotion: String {
        switch self {
        case .red: return "Energy, Passion"
        case .orange: return "Joy"
        case .yellow: return "Optimism"
        case .green: return "Calm"
        case .blue: return "Confidence"
        case .purple: return "Inspiration"
        case .gray: return "Tiredness"
        case .white: return "Neutral"
        }
    }
    
    var color: Color {
        switch self {
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .blue: return .blue
        case .purple: return .purple
        case .gray: return .gray
        case .white: return .white
        }
    }
    
    var uiColor: UIColor {
        switch self {
        case .red: return .systemRed
        case .orange: return .systemOrange
        case .yellow: return .systemYellow
        case .green: return .systemGreen
        case .blue: return .systemBlue
        case .purple: return .systemPurple
        case .gray: return .systemGray
        case .white: return .white
        }
    }
}
