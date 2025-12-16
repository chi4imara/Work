import SwiftUI

extension Color {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.85, blue: 0.0)
    static let primaryWhite = Color.white
    
    static let backgroundGradientStart = Color(red: 0.3, green: 0.6, blue: 0.9)
    static let backgroundGradientEnd = Color(red: 0.5, green: 0.8, blue: 1.0)
    
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.8)
    static let textTertiary = Color.white.opacity(0.6)
    
    static let cardBackground = Color.white.opacity(0.15)
    static let cardBorder = Color.white.opacity(0.3)
    
    static let buttonPrimary = Color.primaryYellow
    static let buttonSecondary = Color.white.opacity(0.2)
    static let buttonText = Color.black
    
    static let destructive = Color.red
    static let success = Color.green
    static let warning = Color.orange
}
