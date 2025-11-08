import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
    static let primaryOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let primaryWhite = Color.white
    
    static let backgroundGradientStart = Color(red: 0.15, green: 0.3, blue: 0.7)
    static let backgroundGradientEnd = Color(red: 0.25, green: 0.5, blue: 0.9)
    
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let accentGreen = Color(red: 0.3, green: 0.8, blue: 0.5)
    static let accentPink = Color(red: 1.0, green: 0.4, blue: 0.7)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let tertiaryText = Color.white.opacity(0.6)
    
    static let cardBackground = Color.white.opacity(0.1)
    static let cardBorder = Color.white.opacity(0.2)
    
    static let success = Color.green
    static let error = Color.red
    static let warning = Color.yellow
}

struct AppGradients {
    static let primaryBackground = LinearGradient(
        colors: [AppColors.backgroundGradientStart, AppColors.backgroundGradientEnd],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [AppColors.cardBackground, AppColors.cardBackground.opacity(0.5)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [AppColors.primaryOrange, AppColors.primaryOrange.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
