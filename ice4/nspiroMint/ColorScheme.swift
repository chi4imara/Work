import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.9, blue: 0.3)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let primaryWhite = Color.white
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryBlue, primaryYellow.opacity(0.7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [primaryPurple.opacity(0.8), primaryBlue.opacity(0.6)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let accentGreen = Color(red: 0.3, green: 0.8, blue: 0.5)
    static let accentPink = Color(red: 1.0, green: 0.4, blue: 0.7)
    
    static let primaryText = primaryWhite
    static let secondaryText = primaryWhite.opacity(0.8)
    static let accentText = primaryPurple
    
    static let buttonBackground = primaryPurple
    static let buttonText = primaryWhite
    static let disabledButton = Color.gray.opacity(0.5)
}

extension Color {
    static let appPrimaryBlue = AppColors.primaryBlue
    static let appPrimaryYellow = AppColors.primaryYellow
    static let appPrimaryPurple = AppColors.primaryPurple
    static let appPrimaryWhite = AppColors.primaryWhite
    static let appAccentOrange = AppColors.accentOrange
    static let appAccentGreen = AppColors.accentGreen
    static let appAccentPink = AppColors.accentPink
}
