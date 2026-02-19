import Foundation
import SwiftUI

enum MoodType: String, CaseIterable, Codable {
    case happy = "happy"
    case sad = "sad"
    case calm = "calm"
    case anxious = "anxious"
    case excited = "excited"
    case tired = "tired"
    case grateful = "grateful"
    case confused = "confused"
    case peaceful = "peaceful"
    case overwhelmed = "overwhelmed"
    
    var displayName: String {
        switch self {
        case .happy: return "Happy"
        case .sad: return "Sad"
        case .calm: return "Calm"
        case .anxious: return "Anxious"
        case .excited: return "Excited"
        case .tired: return "Tired"
        case .grateful: return "Grateful"
        case .confused: return "Confused"
        case .peaceful: return "Peaceful"
        case .overwhelmed: return "Overwhelmed"
        }
    }
    
    var icon: String {
        switch self {
        case .happy: return "face.smiling"
        case .sad: return "face.dashed"
        case .calm: return "leaf"
        case .anxious: return "heart.circle"
        case .excited: return "star.circle"
        case .tired: return "moon.circle"
        case .grateful: return "hands.sparkles"
        case .confused: return "questionmark.circle"
        case .peaceful: return "cloud.sun"
        case .overwhelmed: return "exclamationmark.triangle"
        }
    }
    
    var color: Color {
        switch self {
        case .happy: return ColorTheme.primaryYellow
        case .sad: return ColorTheme.primaryBlue
        case .calm: return ColorTheme.lightGreen
        case .anxious: return ColorTheme.softPink
        case .excited: return ColorTheme.peach
        case .tired: return ColorTheme.lavender
        case .grateful: return ColorTheme.primaryYellow
        case .confused: return ColorTheme.primaryBlue
        case .peaceful: return ColorTheme.lightGreen
        case .overwhelmed: return ColorTheme.softPink
        }
    }
}