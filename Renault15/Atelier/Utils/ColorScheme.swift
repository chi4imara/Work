import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 0.9)
    static let lightBlue = Color(red: 0.6, green: 0.8, blue: 0.95)
    static let darkBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    
    static let primaryYellow = Color(red: 1.0, green: 0.85, blue: 0.2)
    static let lightYellow = Color(red: 1.0, green: 0.95, blue: 0.7)
    
    static let primaryWhite = Color.white
    static let softWhite = Color(red: 0.98, green: 0.98, blue: 0.98)
    
    static let accentPink = Color(red: 0.95, green: 0.6, blue: 0.8)
    static let softPurple = Color(red: 0.7, green: 0.6, blue: 0.9)
    static let lightGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    
    static let primaryGradient = LinearGradient(
        colors: [primaryBlue, lightBlue, softPurple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let secondaryGradient = LinearGradient(
        colors: [lightBlue, primaryBlue],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let accentGradient = LinearGradient(
        colors: [primaryYellow, lightYellow],
        startPoint: .leading,
        endPoint: .trailing
    )
}

struct AppDimensions {
    static let cornerRadius: CGFloat = 16
    static let smallCornerRadius: CGFloat = 8
    static let cardPadding: CGFloat = 16
    static let screenPadding: CGFloat = 20
    static let buttonHeight: CGFloat = 50
    static let cardHeight: CGFloat = 120
    static let iconSize: CGFloat = 24
    static let largeIconSize: CGFloat = 32
}

struct AppFonts {
    static let title = FontManager.playfairBold(size: 28)
    static let subtitle = FontManager.playfairSemiBold(size: 20)
    static let body = FontManager.playfairRegular(size: 16)
    static let caption = FontManager.playfairRegular(size: 14)
    static let button = FontManager.playfairMedium(size: 18)
}
