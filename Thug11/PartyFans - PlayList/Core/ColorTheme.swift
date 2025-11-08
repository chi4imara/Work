import SwiftUI

struct ColorTheme {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let accentOrange = Color(red: 1.0, green: 0.5, blue: 0.0)
    
    static let backgroundGradientStart = Color(red: 0.2, green: 0.5, blue: 0.8)
    static let backgroundGradientEnd = Color(red: 0.6, green: 0.8, blue: 1.0)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let tertiaryText = Color.white.opacity(0.6)
    
    static let cardBackground = Color.white.opacity(0.15)
    static let cardBorder = Color.white.opacity(0.3)
    
    static let buttonPrimary = accentOrange
    static let buttonSecondary = Color.white.opacity(0.2)
    static let buttonText = Color.white
    
    static let accentPurple = Color(red: 0.7, green: 0.4, blue: 1.0)
    static let accentGreen = Color(red: 0.0, green: 0.8, blue: 0.4)
    static let accentPink = Color(red: 1.0, green: 0.4, blue: 0.7)
}

extension Color {
    static let theme = ColorTheme.self
}
