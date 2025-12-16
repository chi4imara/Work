import SwiftUI

struct AppColors {
    static let primaryWhite = Color.white
    static let primaryPurple = Color(red: 0.4, green: 0.2, blue: 0.8)
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    
    static let purpleGradient = LinearGradient(
        colors: [
            Color(red: 0.6, green: 0.3, blue: 0.9),
            Color(red: 0.4, green: 0.2, blue: 0.8),
            Color(red: 0.3, green: 0.1, blue: 0.7)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let backgroundGradient = LinearGradient(
        colors: [
            primaryWhite,
            Color(red: 0.95, green: 0.95, blue: 1.0),
            Color(red: 0.9, green: 0.9, blue: 0.98)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let accentPink = Color(red: 0.9, green: 0.4, blue: 0.6)
    static let accentGreen = Color(red: 0.3, green: 0.7, blue: 0.5)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.3)
    
    static let textPrimary = primaryBlue
    static let textSecondary = Color(red: 0.4, green: 0.4, blue: 0.6)
    static let textLight = Color(red: 0.6, green: 0.6, blue: 0.8)
    
    static let cardBackground = Color.white.opacity(0.9)
    static let shadowColor = Color.black.opacity(0.1)
    static let borderColor = Color(red: 0.9, green: 0.9, blue: 0.95)
    
    static let buttonPrimary = primaryYellow
    static let buttonSecondary = primaryPurple
    static let buttonText = primaryWhite
    
    static let tabBarBackground = primaryWhite.opacity(0.95)
    static let tabBarSelected = primaryPurple
    static let tabBarUnselected = textLight
}

extension Color {
    static let appPrimary = AppColors.primaryPurple
    static let appSecondary = AppColors.primaryBlue
    static let appAccent = AppColors.primaryYellow
    static let appBackground = AppColors.primaryWhite
    static let appText = AppColors.textPrimary
}
