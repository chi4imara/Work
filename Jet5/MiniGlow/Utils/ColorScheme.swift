import SwiftUI

extension Color {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let primaryWhite = Color.white
    
    static let backgroundGradientStart = Color(red: 0.3, green: 0.6, blue: 0.9)
    static let backgroundGradientEnd = Color(red: 0.5, green: 0.8, blue: 1.0)
    
    static let accentPink = Color(red: 1.0, green: 0.6, blue: 0.8)
    static let accentGreen = Color(red: 0.4, green: 0.9, blue: 0.6)
    static let accentYellow = Color(red: 1.0, green: 0.9, blue: 0.4)
    
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.8)
    static let textTertiary = Color.white.opacity(0.6)
    
    static let cardBackground = Color.white.opacity(0.15)
    static let cardBorder = Color.white.opacity(0.3)
    
    static let buttonPrimary = Color.primaryPurple
    static let buttonSecondary = Color.white.opacity(0.2)
    static let buttonDestructive = Color.red.opacity(0.8)
    
    static let statusReady = Color.accentGreen
    static let statusNotReady = Color.accentYellow
    
    static let orbColor1 = Color.white.opacity(0.1)
    static let orbColor2 = Color.white.opacity(0.05)
    static let orbColor3 = Color.primaryPurple.opacity(0.1)
}
