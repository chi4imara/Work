import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    
    static let backgroundWhite = Color.white
    static let backgroundGray = Color(red: 0.98, green: 0.98, blue: 0.99)
    
    static let textPrimary = primaryBlue
    static let textSecondary = Color(red: 0.5, green: 0.5, blue: 0.6)
    static let textLight = Color(red: 0.7, green: 0.7, blue: 0.8)
    
    static let accentGreen = Color(red: 0.3, green: 0.8, blue: 0.6)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.3)
    static let accentPink = Color(red: 1.0, green: 0.5, blue: 0.7)
    
    static let gradientStart = backgroundWhite
    static let gradientMiddle = Color(red: 0.95, green: 0.95, blue: 1.0)
    static let gradientEnd = Color(red: 0.9, green: 0.9, blue: 0.98)
    
    static let orbBlue = primaryBlue.opacity(0.3)
    static let orbPurple = primaryPurple.opacity(0.2)
    static let orbYellow = primaryYellow.opacity(0.25)
    static let orbGreen = accentGreen.opacity(0.2)
    static let orbPink = accentPink.opacity(0.2)
}

struct AppGradients {
    static let backgroundGradient = LinearGradient(
        colors: [AppColors.gradientStart, AppColors.gradientMiddle, AppColors.gradientEnd],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [Color.white.opacity(0.9), Color.white.opacity(0.7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [AppColors.primaryYellow, AppColors.accentOrange],
        startPoint: .leading,
        endPoint: .trailing
    )
}
