import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let primaryWhite = Color.white
    
    static let backgroundGradientStart = Color(red: 0.3, green: 0.6, blue: 0.9)
    static let backgroundGradientEnd = Color(red: 0.5, green: 0.8, blue: 1.0)
    
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.8)
    static let textTertiary = Color.white.opacity(0.6)
    
    static let accentPink = Color(red: 1.0, green: 0.4, blue: 0.7)
    static let accentGreen = Color(red: 0.4, green: 0.9, blue: 0.6)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.3)
    
    static let cardBackground = Color.white.opacity(0.15)
    static let cardBorder = Color.white.opacity(0.3)
    static let buttonBackground = primaryPurple
    static let buttonText = primaryWhite
    
    static let tabBarBackground = Color.white.opacity(0.1)
    static let tabBarSelected = primaryWhite
    static let tabBarUnselected = Color.white.opacity(0.5)
}

struct AppFonts {
    static let largeTitle = Font.playfairDisplay(34, weight: .bold)
    static let title1 = Font.playfairDisplay(28, weight: .semibold)
    static let title2 = Font.playfairDisplay(22, weight: .semibold)
    static let title3 = Font.playfairDisplay(20, weight: .medium)
    static let headline = Font.playfairDisplay(17, weight: .semibold)
    static let body = Font.playfairDisplay(17, weight: .regular)
    static let callout = Font.playfairDisplay(16, weight: .regular)
    static let subheadline = Font.playfairDisplay(15, weight: .regular)
    static let footnote = Font.playfairDisplay(13, weight: .regular)
    static let caption1 = Font.playfairDisplay(12, weight: .regular)
    static let caption2 = Font.playfairDisplay(11, weight: .regular)
}

struct AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

struct AppCornerRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let extraLarge: CGFloat = 24
}

struct AppShadows {
    static let light = Color.black.opacity(0.1)
    static let medium = Color.black.opacity(0.2)
    static let heavy = Color.black.opacity(0.3)
}

struct AppAnimations {
    static let defaultDuration: Double = 0.3
    static let fastDuration: Double = 0.2
    static let slowDuration: Double = 0.5
    static let springResponse: Double = 0.6
    static let springDamping: Double = 0.8
}
