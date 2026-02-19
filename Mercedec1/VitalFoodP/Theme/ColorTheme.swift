import SwiftUI

struct ColorTheme {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let primaryWhite = Color.white
    
    static let backgroundGradientStart = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let backgroundGradientEnd = Color(red: 0.1, green: 0.4, blue: 0.8)
    
    static let accentGreen = Color(red: 0.3, green: 0.8, blue: 0.5)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.3)
    static let accentPurple = Color(red: 0.7, green: 0.4, blue: 0.9)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let accentText = primaryYellow
    
    static let cardBackground = Color.white.opacity(0.15)
    static let cardBorder = Color.white.opacity(0.3)
    
    static let buttonBackground = primaryYellow
    static let buttonText = Color.black
    static let secondaryButtonBackground = Color.white.opacity(0.2)
    static let secondaryButtonText = primaryWhite
}
