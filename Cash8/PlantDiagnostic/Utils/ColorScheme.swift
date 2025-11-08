import SwiftUI

extension Color {
    static let primaryBackground = Color(red: 0.196, green: 0.701, blue: 0.959)
    static let secondaryBackground = Color.white
    static let accentBackground = Color(red: 0.96, green: 0.94, blue: 0.86)
    
    static let primaryText = Color.black
    static let secondaryText = Color.black.opacity(0.8)
    static let invertedText = Color.white
    
    static let accentGreen = Color(red: 0.2, green: 0.7, blue: 0.3)
    static let accentBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let accentPurple = Color(red: 0.6, green: 0.3, blue: 0.8)
    
    static let cardBackground = Color.white.opacity(0.9)
    static let cardShadow = Color.black.opacity(0.1)
    
    static let buttonPrimary = Color(red: 0.8, green: 0.4, blue: 0.4)
    static let buttonSecondary = Color.accentBackground
    static let buttonText = Color.white
}

struct AppGradients {
    static let backgroundGradient = LinearGradient(
        colors: [
            Color.primaryBackground,
            Color.primaryBackground.opacity(0.8),
            Color.primaryBackground.opacity(0.6)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.cardBackground,
            Color.cardBackground.opacity(0.95)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let buttonGradient = LinearGradient(
        colors: [
            Color.buttonPrimary,
            Color.buttonPrimary.opacity(0.8)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}

