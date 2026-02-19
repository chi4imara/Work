import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let primaryWhite = Color.white
    
    static let lightBlue = Color(red: 0.6, green: 0.8, blue: 1.0)
    static let darkBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    static let softYellow = Color(red: 1.0, green: 0.9, blue: 0.6)
    
    static let lightGreen = Color(red: 0.6, green: 0.9, blue: 0.7)
    static let softPink = Color(red: 1.0, green: 0.8, blue: 0.9)
    static let lightPurple = Color(red: 0.8, green: 0.7, blue: 1.0)
    
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.9)
    static let textTertiary = Color.white.opacity(0.75)
    
    static let iconPrimary = Color.white
    static let iconAccent = Color(red: 1.0, green: 0.75, blue: 0.1)
    static let iconSecondary = Color(red: 0.15, green: 0.4, blue: 0.65)
    static let iconMuted = Color(red: 0.25, green: 0.5, blue: 0.8)        
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryBlue, lightBlue, primaryBlue.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.1)
    static let cardBorder = Color.white.opacity(0.2)
}

struct AppFonts {
    static func title1() -> Font { .ubuntu(28, weight: .bold) }
    static func title2() -> Font { .ubuntu(24, weight: .bold) }
    static func title3() -> Font { .ubuntu(20, weight: .medium) }
    static func headline() -> Font { .ubuntu(18, weight: .medium) }
    static func body() -> Font { .ubuntu(16, weight: .regular) }
    static func callout() -> Font { .ubuntu(14, weight: .regular) }
    static func caption() -> Font { .ubuntu(12, weight: .regular) }
    static func caption2() -> Font { .ubuntu(10, weight: .regular) }
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
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
}

struct AppShadows {
    static let soft = Color.black.opacity(0.1)
    static let medium = Color.black.opacity(0.2)
    static let strong = Color.black.opacity(0.3)
}

struct AppAnimations {
    static let fast: Double = 0.2
    static let medium: Double = 0.3
    static let slow: Double = 0.5
    static let verySlow: Double = 1.0
}
