import SwiftUI

struct ColorTheme {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let lightBlue = Color(red: 0.6, green: 0.8, blue: 1.0)
    static let darkBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    
    static let accentYellow = Color(red: 1.0, green: 0.9, blue: 0.2)
    static let lightYellow = Color(red: 1.0, green: 0.95, blue: 0.6)
    
    static let textWhite = Color.white
    static let textGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    
    static let cardBackground = Color.white.opacity(0.1)
    static let cardBorder = Color.white.opacity(0.3)
    
    static let successGreen = Color(red: 0.3, green: 0.8, blue: 0.4)
    static let warningOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let errorRed = Color(red: 0.9, green: 0.3, blue: 0.3)
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [primaryBlue, lightBlue, darkBlue]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [cardBackground, cardBackground.opacity(0.05)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        gradient: Gradient(colors: [accentYellow, lightYellow]),
        startPoint: .leading,
        endPoint: .trailing
    )
}

extension Color {
    static let theme = ColorTheme.self
}
