import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
    static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let backgroundWhite = Color.white
    
    static let purpleGradientStart = Color(red: 0.8, green: 0.6, blue: 1.0)
    static let purpleGradientEnd = Color(red: 0.9, green: 0.8, blue: 1.0)
    
    static let softGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let lightPurple = Color(red: 0.85, green: 0.75, blue: 0.95)
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warningRed = Color(red: 0.9, green: 0.3, blue: 0.3)
    
    static let mainBackgroundGradient = LinearGradient(
        colors: [backgroundWhite, purpleGradientStart, purpleGradientEnd],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [backgroundWhite.opacity(0.9), lightPurple.opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct AppFonts {
    static func ubuntu(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let fontName: String
        switch weight {
        case .bold:
            fontName = "Ubuntu-Bold"
        case .medium:
            fontName = "Ubuntu-Medium"
        case .light:
            fontName = "Ubuntu-Light"
        default:
            fontName = "Ubuntu-Regular"
        }
        return Font.custom(fontName, size: size)
    }
    
    static let title = ubuntu(24, weight: .bold)
    static let headline = ubuntu(20, weight: .medium)
    static let body = ubuntu(16)
    static let caption = ubuntu(14, weight: .light)
    static let small = ubuntu(12)
}
