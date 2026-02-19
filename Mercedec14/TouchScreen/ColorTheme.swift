import SwiftUI

struct ColorTheme {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let backgroundWhite = Color.white
    static let bubbleBlue = Color(red: 0.4, green: 0.7, blue: 1.0).opacity(0.6)
    
    static let textPrimary = Color(red: 0.1, green: 0.1, blue: 0.1)
    static let textSecondary = Color(red: 0.4, green: 0.4, blue: 0.4)
    static let cardBackground = Color.white.opacity(0.9)
    static let shadowColor = Color.black.opacity(0.1)
    
    static let successGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warningOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let errorRed = Color(red: 1.0, green: 0.3, blue: 0.3)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color.white,
            Color(red: 0.95, green: 0.98, blue: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.95),
            Color(red: 0.98, green: 0.99, blue: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [
            primaryYellow,
            Color(red: 1.0, green: 0.9, blue: 0.2)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    static let theme = ColorTheme.self
}
