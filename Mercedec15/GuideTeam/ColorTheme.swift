import SwiftUI

struct ColorTheme {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let primaryWhite = Color.white
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.3, green: 0.6, blue: 0.9),
            Color(red: 0.5, green: 0.4, blue: 0.8),
            Color(red: 0.4, green: 0.7, blue: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentPink = Color(red: 0.9, green: 0.5, blue: 0.7)
    static let accentGreen = Color(red: 0.4, green: 0.8, blue: 0.6)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.4)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let darkText = Color.black
    
    static let cardBackground = Color.white.opacity(0.15)
    static let cardBorder = Color.white.opacity(0.3)
    
    static let buttonPrimary = primaryPurple
    static let buttonSecondary = primaryBlue
    static let buttonText = primaryWhite
    
    static let statusSuccess = accentGreen
    static let statusWarning = accentOrange
    static let statusError = Color.red.opacity(0.8)
}
