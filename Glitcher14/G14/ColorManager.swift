import SwiftUI

struct ColorManager {
    static let primaryBackground = Color(red: 0.4, green: 0.7, blue: 0.95)
    static let secondaryBackground = Color(red: 0.5, green: 0.75, blue: 0.98)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.9)
    
    static let accent = Color(red: 1.0, green: 0.85, blue: 0.0)
    static let yellow = Color(red: 1.0, green: 0.9, blue: 0.2)
    static let orange = Color(red: 1.0, green: 0.7, blue: 0.3)
    static let green = Color(red: 0.4, green: 0.9, blue: 0.6)
    static let pink = Color(red: 1.0, green: 0.6, blue: 0.8)
    static let purple = Color(red: 0.7, green: 0.5, blue: 1.0)
    
    static let cardBackground = Color.white.opacity(0.2)
    static let buttonBackground = Color.white.opacity(0.25)
    static let divider = Color.white.opacity(0.3)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.35, green: 0.65, blue: 0.9),
            Color(red: 0.45, green: 0.75, blue: 0.95),
            Color(red: 0.5, green: 0.8, blue: 1.0),
            Color(red: 0.4, green: 0.7, blue: 0.95)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.25),
            Color.white.opacity(0.15)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
