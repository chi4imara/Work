import SwiftUI

struct AppColors {
    static let skyBlue = Color(red: 0.53, green: 0.81, blue: 0.92)
    static let white = Color.white
    static let yellow = Color(red: 1.0, green: 0.84, blue: 0.0)
    
    static let softPink = Color(red: 1.0, green: 0.75, blue: 0.8)
    static let lightGreen = Color(red: 0.68, green: 0.85, blue: 0.68)
    static let lavender = Color(red: 0.9, green: 0.9, blue: 0.98)
    static let coral = Color(red: 1.0, green: 0.5, blue: 0.31)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let accentText = Color.yellow
    
    static let backgroundGradient = LinearGradient(
        colors: [skyBlue, skyBlue.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [white.opacity(0.2), white.opacity(0.1)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    static let appSkyBlue = AppColors.skyBlue
    static let appWhite = AppColors.white
    static let appYellow = AppColors.yellow
    static let appSoftPink = AppColors.softPink
    static let appLightGreen = AppColors.lightGreen
    static let appLavender = AppColors.lavender
    static let appCoral = AppColors.coral
    static let appPrimaryText = AppColors.primaryText
    static let appSecondaryText = AppColors.secondaryText
    static let appAccentText = AppColors.accentText
}

