import SwiftUI

struct ColorTheme {
    static let darkBlue = Color(red: 0.1, green: 0.2, blue: 0.4)
    static let lightBlue = Color(red: 0.3, green: 0.6, blue: 0.9)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    static let primaryBackground = darkBlue
    static let secondaryBackground = Color(red: 0.15, green: 0.25, blue: 0.45)
    static let cardBackground = Color(red: 0.2, green: 0.3, blue: 0.5).opacity(0.3)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let accentText = lightBlue
    
    static let primaryButton = lightBlue
    static let secondaryButton = orange
    static let destructiveButton = Color.red
    
    static let success = Color.green
    static let warning = Color.yellow
    static let accent = Color(red: 0.5, green: 0.8, blue: 1.0)
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            darkBlue,
            Color(red: 0.15, green: 0.25, blue: 0.45),
            Color(red: 0.2, green: 0.3, blue: 0.5)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.white.opacity(0.1),
            Color.white.opacity(0.05)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        gradient: Gradient(colors: [
            lightBlue,
            Color(red: 0.2, green: 0.5, blue: 0.8)
        ]),
        startPoint: .leading,
        endPoint: .trailing
    )
}
