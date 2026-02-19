import SwiftUI

extension Color {
    static let primaryPurple = Color(red: 0.9, green: 0.4, blue: 0.7)
    static let primaryWhite = Color.white
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    
    static let secondaryPink = Color(red: 0.9, green: 0.4, blue: 0.7)
    static let secondaryBlue = Color(red: 0.3, green: 0.5, blue: 0.9)
    static let secondaryGreen = Color(red: 0.2, green: 0.8, blue: 0.5)
    
    static let backgroundGradientStart = Color(red: 0.8, green: 0.3, blue: 0.6)
    static let backgroundGradientEnd = Color(red: 0.95, green: 0.5, blue: 0.8)
    
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.8)
    
    static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let accentRed = Color(red: 0.9, green: 0.3, blue: 0.3)
    
    static let cardBackground = Color.white.opacity(0.1)
    static let cardBorder = Color.white.opacity(0.2)
}

struct AppColorScheme {
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color.backgroundGradientStart, Color.backgroundGradientEnd]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [Color.cardBackground, Color.cardBackground.opacity(0.05)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
