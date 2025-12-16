import SwiftUI

struct AppTheme {
    struct Colors {
        static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
        static let lightBlue = Color(red: 0.6, green: 0.8, blue: 1.0)
        static let darkBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
        
        static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
        static let lightPurple = Color(red: 0.7, green: 0.5, blue: 0.95)
        static let darkPurple = Color(red: 0.5, green: 0.3, blue: 0.8)
        
        static let primaryText = Color.white
        static let secondaryText = Color.white.opacity(0.8)
        static let tertiaryText = Color.white.opacity(0.6)
        
        static let background = LinearGradient(
            colors: [primaryBlue, lightBlue, primaryPurple.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let cardBackground = Color.white.opacity(0.15)
        static let overlayBackground = Color.black.opacity(0.3)
        
        static let accent = primaryPurple
        static let success = Color.green
        static let warning = Color.orange
        static let error = Color.red
        
        static let orb1 = Color.white.opacity(0.1)
        static let orb2 = Color.white.opacity(0.05)
        static let orb3 = Color.white.opacity(0.08)
    }
    
    struct Typography {
        static let largeTitle = Font.playfairDisplay(34, weight: .bold)
        static let title1 = Font.playfairDisplay(28, weight: .semibold)
        static let title2 = Font.playfairDisplay(22, weight: .medium)
        static let title3 = Font.playfairDisplay(20, weight: .medium)
        static let headline = Font.playfairDisplay(17, weight: .semibold)
        static let body = Font.playfairDisplay(17, weight: .regular)
        static let callout = Font.playfairDisplay(16, weight: .regular)
        static let subheadline = Font.playfairDisplay(15, weight: .regular)
        static let footnote = Font.playfairDisplay(13, weight: .regular)
        static let caption1 = Font.playfairDisplay(12, weight: .regular)
        static let caption2 = Font.playfairDisplay(11, weight: .regular)
    }
    
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    struct CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
    }
    
    struct Shadow {
        static let light = Color.black.opacity(0.1)
        static let medium = Color.black.opacity(0.2)
        static let heavy = Color.black.opacity(0.3)
    }
}
