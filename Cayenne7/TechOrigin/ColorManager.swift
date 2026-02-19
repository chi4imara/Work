import SwiftUI

struct AppColors {
    static let primaryBackground = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let secondaryBackground = Color(red: 0.15, green: 0.2, blue: 0.35)
    
    static let primaryText = Color.white
    static let secondaryText = Color(red: 0.8, green: 0.85, blue: 0.9)
    
    static let accentBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 1.0)
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    
    static let primaryGradient = LinearGradient(
        colors: [
            Color(red: 0.08, green: 0.12, blue: 0.25),
            Color(red: 0.12, green: 0.18, blue: 0.35),
            Color(red: 0.15, green: 0.22, blue: 0.4)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color(red: 0.15, green: 0.2, blue: 0.35).opacity(0.8),
            Color(red: 0.2, green: 0.25, blue: 0.4).opacity(0.6)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonPrimary = accentBlue
    static let buttonSecondary = accentOrange
    static let buttonDanger = Color(red: 0.9, green: 0.3, blue: 0.3)
    
    static let success = accentGreen
    static let warning = accentOrange
    static let error = Color(red: 0.9, green: 0.3, blue: 0.3)
}

extension Color {
    static let appPrimary = AppColors.primaryBackground
    static let appSecondary = AppColors.secondaryBackground
    static let appText = AppColors.primaryText
    static let appTextSecondary = AppColors.secondaryText
    static let appAccent = AppColors.accentBlue
    static let appAccentOrange = AppColors.accentOrange
}
