import SwiftUI

struct ColorTheme {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let primaryWhite = Color.white
    
    static let backgroundGradientStart = Color(red: 0.95, green: 0.97, blue: 1.0)
    static let backgroundGradientEnd = Color(red: 0.98, green: 0.95, blue: 0.92)
    
    static let primaryText = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let secondaryText = Color(red: 0.4, green: 0.4, blue: 0.4)
    static let lightText = Color.white
    
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let accentPink = Color(red: 1.0, green: 0.4, blue: 0.6)
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    
    static let cardBackground = Color.white.opacity(0.9)
    static let cardShadow = Color.black.opacity(0.1)
    
    static let buttonBackground = primaryYellow
    static let buttonText = Color.black
    static let secondaryButtonBackground = primaryBlue
    static let secondaryButtonText = Color.white
}

extension Color {
    static let theme = ColorTheme.self
}
