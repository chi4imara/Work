import SwiftUI

struct ColorTheme {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let lightBlue = Color(red: 0.6, green: 0.8, blue: 1.0)
    static let darkBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    
    static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let brightYellow = Color(red: 1.0, green: 0.9, blue: 0.3)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let accentText = Color(red: 1.0, green: 0.8, blue: 0.2)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.3, green: 0.6, blue: 0.9),
            Color(red: 0.5, green: 0.7, blue: 1.0),
            Color(red: 0.4, green: 0.65, blue: 0.95)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.15)
    static let cardBorder = Color.white.opacity(0.3)
    
    static let buttonPrimary = accentYellow
    static let buttonSecondary = Color.white.opacity(0.2)
    static let buttonText = Color.black
    static let buttonSecondaryText = Color.white
    
    static let success = Color.green
    static let error = Color.red
    static let warning = Color.orange
    
    static let sphereColors = [
        Color.white.opacity(0.1),
        Color.white.opacity(0.15),
        Color.white.opacity(0.08),
        Color(red: 1.0, green: 0.9, blue: 0.3).opacity(0.1)
    ]
}
