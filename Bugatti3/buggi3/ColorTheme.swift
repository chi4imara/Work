import SwiftUI

struct ColorTheme {
    static let lightBlue = Color(red: 0.35, green: 0.65, blue: 1.0)
    
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let primaryWhite = Color.white
    
    static let backgroundGradientStart = Color.white
    static let backgroundGradientEnd = Color.white
    
    static let accentPink = Color(red: 1.0, green: 0.4, blue: 0.7)
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentPurple = Color(red: 0.6, green: 0.3, blue: 1.0)
    
    static let primaryText = lightBlue
    static let secondaryText = lightBlue.opacity(0.8)
    
    static let cardBackground = lightBlue.opacity(0.08)
    static let cardBorder = lightBlue.opacity(0.25)
    
    static let buttonBackground = lightBlue
    static let buttonText = Color.white
    static let secondaryButtonBackground = lightBlue.opacity(0.2)
    static let secondaryButtonText = lightBlue
    
    static let destructive = Color.red
    static let success = accentGreen
    static let warning = primaryYellow
}

extension Color {
    static let theme = ColorTheme.self
}
