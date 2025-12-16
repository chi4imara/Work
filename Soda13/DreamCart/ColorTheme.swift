import SwiftUI

struct ColorTheme {
    static let primaryWhite = Color.white
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.8)
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    
    static let purpleGradient = LinearGradient(
        colors: [Color(red: 0.5, green: 0.3, blue: 0.7), Color(red: 0.7, green: 0.5, blue: 0.9)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryWhite, Color(red: 0.95, green: 0.95, blue: 1.0)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let accentPink = Color(red: 0.9, green: 0.5, blue: 0.7)
    static let softGreen = Color(red: 0.5, green: 0.8, blue: 0.6)
    static let lightGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let darkText = Color(red: 0.2, green: 0.2, blue: 0.3)
    
    static let primaryText = darkText
    static let secondaryText = Color(red: 0.5, green: 0.5, blue: 0.6)
    static let accentText = primaryBlue
    
    static let buttonBackground = primaryYellow
    static let buttonText = darkText
    static let secondaryButtonBackground = primaryBlue
    static let secondaryButtonText = primaryWhite
    
    static let cardBackground = primaryWhite
    static let cardShadow = Color.black.opacity(0.1)
}

extension Color {
    static let theme = ColorTheme.self
}
