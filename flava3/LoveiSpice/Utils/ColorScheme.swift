import SwiftUI

extension Color {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let primaryWhite = Color.white
    
    static let backgroundGradientStart = Color(red: 0.1, green: 0.2, blue: 0.4)
    static let backgroundGradientMiddle = Color(red: 0.2, green: 0.4, blue: 0.7)
    static let backgroundGradientEnd = Color(red: 0.4, green: 0.6, blue: 0.9)
    static let backgroundGradientBottom = Color(red: 0.3, green: 0.5, blue: 0.8)
    
    static let accentPurple = Color(red: 0.5, green: 0.3, blue: 0.8)
    static let accentBlue = Color(red: 0.3, green: 0.6, blue: 1.0)
    static let accentTeal = Color(red: 0.2, green: 0.7, blue: 0.8)
    
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let accentRed = Color(red: 0.9, green: 0.3, blue: 0.3)
    
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.8)
    static let textTertiary = Color.white.opacity(0.6)
    
    static let cardBackground = Color.white.opacity(0.15)
    static let cardBorder = Color.white.opacity(0.3)
}

struct AppColors {
    static let primary = Color.primaryBlue
    static let secondary = Color.primaryPurple
    static let background = LinearGradient(
        colors: [Color.backgroundGradientStart, Color.backgroundGradientMiddle, Color.backgroundGradientEnd],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let enhancedBackground = LinearGradient(
        colors: [
            Color.backgroundGradientStart,
            Color.backgroundGradientMiddle,
            Color.backgroundGradientEnd,
            Color.backgroundGradientBottom
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let secondaryGradient = LinearGradient(
        colors: [
            Color.accentPurple.opacity(0.3),
            Color.accentBlue.opacity(0.2),
            Color.accentTeal.opacity(0.1)
        ],
        startPoint: .topTrailing,
        endPoint: .bottomLeading
    )
    
    static let cardBackground = Color.cardBackground
    static let text = Color.textPrimary
    static let textSecondary = Color.textSecondary
}
