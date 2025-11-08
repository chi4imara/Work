import SwiftUI

struct AppColors {
    static let primary = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let secondary = Color(red: 0.4, green: 0.8, blue: 1.0)
    static let accent = Color(red: 0.1, green: 0.4, blue: 0.8)
    
    static let background = Color.white
    static let cardBackground = Color(red: 0.98, green: 0.99, blue: 1.0)
    static let surfaceBackground = Color(red: 0.95, green: 0.97, blue: 1.0)
    
    static let primaryText = Color(red: 0.1, green: 0.1, blue: 0.2)
    static let secondaryText = Color(red: 0.4, green: 0.5, blue: 0.6)
    static let lightText = Color(red: 0.6, green: 0.7, blue: 0.8)
    static let onPrimary = Color.white
    
    static let buttonPrimary = primary
    static let buttonSecondary = secondary
    static let buttonDisabled = Color(red: 0.8, green: 0.85, blue: 0.9)
    
    static let success = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warning = Color(red: 1.0, green: 0.7, blue: 0.2)
    static let error = Color(red: 1.0, green: 0.3, blue: 0.3)
    
    static let bubbleBlue1 = Color(red: 0.6, green: 0.85, blue: 1.0).opacity(0.3)
    static let bubbleBlue2 = Color(red: 0.4, green: 0.75, blue: 1.0).opacity(0.4)
    static let bubbleBlue3 = Color(red: 0.5, green: 0.8, blue: 1.0).opacity(0.2)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color.white,
            Color(red: 0.96, green: 0.98, blue: 1.0),
            Color(red: 0.94, green: 0.96, blue: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color(red: 0.98, green: 0.99, blue: 1.0),
            Color(red: 0.96, green: 0.98, blue: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let primaryGradient = LinearGradient(
        colors: [primary, secondary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentGradient = LinearGradient(
        colors: [accent, primary],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    static let appPrimary = AppColors.primary
    static let appSecondary = AppColors.secondary
    static let appAccent = AppColors.accent
    static let appBackground = AppColors.background
    static let appCardBackground = AppColors.cardBackground
    static let appSurfaceBackground = AppColors.surfaceBackground
    static let appPrimaryText = AppColors.primaryText
    static let appSecondaryText = AppColors.secondaryText
    static let appLightText = AppColors.lightText
}
