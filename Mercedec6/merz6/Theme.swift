import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let secondaryBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    
    static let backgroundGradientStart = Color(red: 0.3, green: 0.6, blue: 0.9)
    static let backgroundGradientEnd = Color(red: 0.1, green: 0.4, blue: 0.7)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let accentText = Color(red: 1.0, green: 0.8, blue: 0.2)
    
    static let cardBackground = Color.white.opacity(0.1)
    static let cardBorder = Color.white.opacity(0.2)
    
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    static let energyColor = Color.orange
    static let relaxColor = Color.purple
    static let focusColor = Color.green
}

struct AppGradients {
    static let primaryBackground = LinearGradient(
        gradient: Gradient(colors: [AppColors.backgroundGradientStart, AppColors.backgroundGradientEnd]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [AppColors.cardBackground, AppColors.cardBackground.opacity(0.05)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct AppFonts {
    static let largeTitle = Font.ubuntu(32, weight: .bold)
    static let title = Font.ubuntu(24, weight: .bold)
    static let headline = Font.ubuntu(20, weight: .medium)
    static let body = Font.ubuntu(16, weight: .regular)
    static let caption = Font.ubuntu(14, weight: .regular)
    static let small = Font.ubuntu(12, weight: .regular)
}

struct AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

struct AppRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let xl: CGFloat = 24
}

struct AppShadow {
    static let light = Color.black.opacity(0.1)
    static let medium = Color.black.opacity(0.2)
    static let heavy = Color.black.opacity(0.3)
}
