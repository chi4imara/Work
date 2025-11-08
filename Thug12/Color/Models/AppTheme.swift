import SwiftUI

struct AppColors {
    static let backgroundBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let primaryOrange = Color(red: 1.0, green: 0.5, blue: 0.2)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.3, green: 0.6, blue: 0.9),
            Color(red: 0.5, green: 0.8, blue: 1.0),
            Color(red: 0.4, green: 0.7, blue: 0.95)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.2),
            Color.white.opacity(0.1)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let success = Color.green
    static let warning = Color.yellow
    static let error = Color.red
    static let info = Color.blue
}

struct AppFonts {
    static let largeTitle = Font.poppinsBold(size: 20)
    static let title = Font.poppinsSemiBold(size: 18)
    static let title2 = Font.poppinsSemiBold(size: 16)
    static let headline = Font.poppinsSemiBold(size: 14)
    static let body = Font.poppinsRegular(size: 12)
    static let callout = Font.poppinsRegular(size: 12)
    static let subheadline = Font.poppinsRegular(size: 11)
    static let footnote = Font.poppinsRegular(size: 10)
    static let caption = Font.poppinsRegular(size: 9)
    
    static let button = Font.poppinsMedium(size: 12)
    static let navigationTitle = Font.poppinsBold(size: 16)
    static let cardTitle = Font.poppinsSemiBold(size: 14)
    static let cardSubtitle = Font.poppinsRegular(size: 11)
}

struct AppSpacing {
    static let xs: CGFloat = 3
    static let sm: CGFloat = 6
    static let md: CGFloat = 12
    static let lg: CGFloat = 18
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 36
}

struct AppCornerRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let extraLarge: CGFloat = 24
}
