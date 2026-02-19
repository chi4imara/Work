import SwiftUI

struct ColorTheme {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let backgroundWhite = Color.white
    
    static let lightBlue = Color(red: 0.7, green: 0.85, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.3, blue: 0.6)
    static let lightYellow = Color(red: 1.0, green: 0.95, blue: 0.7)
    static let darkYellow = Color(red: 0.8, green: 0.6, blue: 0.0)
    
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let accentOrange = Color(red: 1.0, green: 0.5, blue: 0.2)
    
    static let textPrimary = primaryBlue
    static let textSecondary = Color.gray
    static let textLight = Color.white
    
    static let backgroundGradient = LinearGradient(
        colors: [backgroundWhite, lightBlue.opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [backgroundWhite, lightBlue.opacity(0.1)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let primaryButtonGradient = LinearGradient(
        colors: [primaryYellow, darkYellow],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let secondaryButtonGradient = LinearGradient(
        colors: [primaryBlue, darkBlue],
        startPoint: .top,
        endPoint: .bottom
    )
}
