import SwiftUI

struct ColorTheme {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let primaryWhite = Color.white
    
    static let backgroundGradientStart = Color(red: 0.5, green: 0.8, blue: 1.0)
    static let backgroundGradientEnd = Color(red: 0.3, green: 0.6, blue: 0.9)
    
    static let accentGold = Color(red: 1.0, green: 0.8, blue: 0.4)
    static let accentPink = Color(red: 1.0, green: 0.7, blue: 0.8)
    static let accentMint = Color(red: 0.7, green: 1.0, blue: 0.9)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let placeholderText = Color.white.opacity(0.6)
    
    static let cardBackground = Color.white.opacity(0.15)
    static let cardBorder = Color.white.opacity(0.3)
    
    static let tabBarBackground = Color.white.opacity(0.3)
    static let tabBarSelected = primaryPurple
    static let tabBarUnselected = Color.white.opacity(0.6)
    
    static let orbColor1 = Color.white.opacity(0.3)
    static let orbColor2 = Color.white.opacity(0.2)
    static let orbColor3 = Color.white.opacity(0.25)
}

extension Color {
    static let theme = ColorTheme.self
}
