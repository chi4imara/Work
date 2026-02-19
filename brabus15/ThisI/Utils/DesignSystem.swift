import SwiftUI

struct DesignSystem {
    struct Colors {
        static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 0.9)
        static let lightBlue = Color(red: 0.4, green: 0.7, blue: 0.95)
        static let darkBlue = Color(red: 0.1, green: 0.4, blue: 0.7)
        
        static let yellow = Color(red: 1.0, green: 0.8, blue: 0.0)
        static let brightYellow = Color(red: 1.0, green: 0.9, blue: 0.2)
        
        static let primaryText = Color.white
        static let secondaryText = Color.white.opacity(0.8)
        static let placeholderText = Color.white.opacity(0.6)
        
        static let cardBackground = Color.white.opacity(0.1)
        static let overlayBackground = Color.black.opacity(0.3)
        
        static let success = Color.green
        static let warning = Color.orange
        static let error = Color.red
        
        static let particleWhite = Color.white.opacity(0.7)
    }
    
    struct Gradients {
        static let primaryBackground = LinearGradient(
            colors: [Color.yellow.opacity(0.03), Colors.lightBlue, Colors.primaryBlue, Colors.darkBlue],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let cardGradient = LinearGradient(
            colors: [Colors.cardBackground, Colors.cardBackground.opacity(0.5)],
            startPoint: .top,
            endPoint: .bottom
        )
        
        static let buttonGradient = LinearGradient(
            colors: [Colors.yellow, Colors.brightYellow],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    struct Typography {
        static let largeTitle = Font.ubuntu(28, weight: .bold)
        static let title = Font.ubuntu(24, weight: .bold)
        static let title2 = Font.ubuntu(20, weight: .medium)
        static let headline = Font.ubuntu(18, weight: .medium)
        static let body = Font.ubuntu(16, weight: .regular)
        static let callout = Font.ubuntu(14, weight: .regular)
        static let caption = Font.ubuntu(12, weight: .regular)
        static let caption2 = Font.ubuntu(10, weight: .regular)
    }
    
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 30
    }
    
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
    }
    
    struct Shadows {
        static let card = Color.black.opacity(0.1)
        static let button = Color.black.opacity(0.2)
    }
}
