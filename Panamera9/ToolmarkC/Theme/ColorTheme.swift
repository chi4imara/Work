import SwiftUI

struct ColorTheme {
    static let primaryBackground = Color(red: 0.08, green: 0.12, blue: 0.25)
    static let secondaryBackground = Color(red: 0.12, green: 0.16, blue: 0.30) 
    static let accentOrange = Color(red: 1.0, green: 0.45, blue: 0.0)
    
    static let primaryText = Color.white
    static let secondaryText = Color(red: 0.8, green: 0.8, blue: 0.85)
    static let mutedText = Color(red: 0.6, green: 0.6, blue: 0.7)
    
    static let cardBackground = Color(red: 0.15, green: 0.20, blue: 0.35)
    static let inputBackground = Color(red: 0.18, green: 0.22, blue: 0.38)
    static let borderColor = Color(red: 0.25, green: 0.30, blue: 0.45)
    
    static let successGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warningYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let errorRed = Color(red: 0.9, green: 0.2, blue: 0.2)
    
    static let movingOrbColor = accentOrange.opacity(0.6)
    static let glowColor = accentOrange.opacity(0.3)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            primaryBackground,
            secondaryBackground,
            Color(red: 0.10, green: 0.14, blue: 0.28)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            cardBackground,
            cardBackground.opacity(0.8)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentGradient = LinearGradient(
        colors: [
            accentOrange,
            Color(red: 1.0, green: 0.6, blue: 0.1)
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
}

extension Color {
    static let theme = ColorTheme.self
}
