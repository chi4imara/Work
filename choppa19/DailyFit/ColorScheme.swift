import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.8)
    
    static let backgroundGradientStart = Color(red: 0.3, green: 0.6, blue: 0.9)
    static let backgroundGradientEnd = Color(red: 0.2, green: 0.4, blue: 0.7)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let accentText = Color(red: 1.0, green: 0.9, blue: 0.3)
    
    static let cardBackground = Color.white.opacity(0.15)
    static let buttonBackground = primaryPurple
    static let buttonText = Color.white
    
    static let favoriteHeart = Color.red
    static let successGreen = Color.green
    static let warningOrange = Color.orange
    static let errorRed = Color.red
    
    static let mainBackgroundGradient = LinearGradient(
        gradient: Gradient(colors: [backgroundGradientStart, backgroundGradientEnd]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let yellowAccentGradient = LinearGradient(
        gradient: Gradient(colors: [primaryYellow, primaryYellow.opacity(0.7)]),
        startPoint: .leading,
        endPoint: .trailing
    )
}

extension Color {
    static let appPrimary = AppColors.primaryBlue
    static let appSecondary = AppColors.primaryYellow
    static let appAccent = AppColors.primaryPurple
    static let appBackground = AppColors.backgroundGradientStart
    static let appText = AppColors.primaryText
}
