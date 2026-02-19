import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let tertiaryText = Color.white.opacity(0.6)
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryBlue, primaryPurple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.1)
    static let cardBackgroundSelected = Color.white.opacity(0.2)
    
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    static let info = Color.blue
    
    static let buttonPrimary = accentYellow
    static let buttonSecondary = Color.white.opacity(0.2)
    static let buttonText = Color.black
    static let buttonTextSecondary = Color.white
    
    static let borderPrimary = Color.white.opacity(0.3)
    static let borderSecondary = Color.white.opacity(0.1)
}

extension Color {
    static let appPrimaryBlue = AppColors.primaryBlue
    static let appPrimaryPurple = AppColors.primaryPurple
    static let appAccentYellow = AppColors.accentYellow
    static let appPrimaryText = AppColors.primaryText
    static let appSecondaryText = AppColors.secondaryText
    static let appTertiaryText = AppColors.tertiaryText
    static let appCardBackground = AppColors.cardBackground
    static let appButtonPrimary = AppColors.buttonPrimary
    static let appButtonSecondary = AppColors.buttonSecondary
}
