import SwiftUI

extension Color {
    static let primaryPink = Color(red: 0.9, green: 0.4, blue: 0.7)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let primaryWhite = Color.white
    
    static let accentBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let accentPurple = Color(red: 0.4, green: 0.2, blue: 0.8)
    static let accentGreen = Color(red: 0.3, green: 0.8, blue: 0.5)
    
    static let backgroundGradientStart = Color(red: 0.8, green: 0.2, blue: 0.5)
    static let backgroundGradientEnd = Color(red: 0.9, green: 0.5, blue: 0.7)
    static let backgroundSecondary = Color(red: 0.8, green: 0.3, blue: 0.6).opacity(0.8)
    
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.8)
    static let textAccent = Color.primaryYellow
    
    static let cardBackground = Color.white.opacity(0.1)
    static let cardBorder = Color.white.opacity(0.2)
    
    static let buttonPrimary = Color.primaryYellow
    static let buttonSecondary = Color.white.opacity(0.2)
    static let buttonDanger = Color.red
}

struct AppColorScheme {
    static let background = LinearGradient(
        gradient: Gradient(colors: [Color.backgroundGradientStart, Color.backgroundGradientEnd]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [Color.cardBackground, Color.cardBackground.opacity(0.5)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
