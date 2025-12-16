import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let primaryWhite = Color.white
    
    static let backgroundGradientStart = Color(red: 0.3, green: 0.6, blue: 0.9)
    static let backgroundGradientEnd = Color(red: 0.5, green: 0.8, blue: 1.0)
    
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentRed = Color(red: 1.0, green: 0.3, blue: 0.3)
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.8)
    static let textTertiary = Color.white.opacity(0.6)
    
    static let cardBackground = Color.white.opacity(0.1)
    static let cardBorder = Color.white.opacity(0.2)
}

extension Color {
    static let appPrimaryBlue = AppColors.primaryBlue
    static let appPrimaryYellow = AppColors.primaryYellow
    static let appPrimaryWhite = AppColors.primaryWhite
    static let appBackgroundStart = AppColors.backgroundGradientStart
    static let appBackgroundEnd = AppColors.backgroundGradientEnd
    static let appAccentGreen = AppColors.accentGreen
    static let appAccentRed = AppColors.accentRed
    static let appAccentPurple = AppColors.accentPurple
    static let appTextPrimary = AppColors.textPrimary
    static let appTextSecondary = AppColors.textSecondary
    static let appTextTertiary = AppColors.textTertiary
    static let appCardBackground = AppColors.cardBackground
    static let appCardBorder = AppColors.cardBorder
}
