import SwiftUI

struct ColorTheme {
    static let primaryWhite = Color.white
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.8)
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    
    static let lightPurple = Color(red: 0.8, green: 0.7, blue: 0.9)
    static let darkPurple = Color(red: 0.4, green: 0.2, blue: 0.6)
    static let lightBlue = Color(red: 0.7, green: 0.9, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.4, blue: 0.7)
    static let lightYellow = Color(red: 1.0, green: 0.95, blue: 0.8)
    static let darkYellow = Color(red: 0.8, green: 0.6, blue: 0.1)
    
    static let purpleGradient = LinearGradient(
        colors: [primaryPurple, darkPurple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryWhite, lightPurple.opacity(0.3)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let cardGradient = LinearGradient(
        colors: [primaryWhite, lightBlue.opacity(0.2)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let primaryText = primaryBlue
    static let secondaryText = darkPurple
    static let accentText = darkYellow
    
    static let buttonBackground = primaryYellow
    static let buttonText = darkPurple
    static let cardBackground = primaryWhite
    static let shadowColor = darkPurple.opacity(0.2)
}

extension Color {
    static let theme = ColorTheme.self
}
