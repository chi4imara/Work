import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.85, blue: 0.0)
    static let primaryWhite = Color.white
    
    static let secondaryGreen = Color(red: 0.3, green: 0.8, blue: 0.4)
    static let secondaryOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let secondaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let secondaryPink = Color(red: 1.0, green: 0.4, blue: 0.7)
    
    static let backgroundBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.3, green: 0.6, blue: 0.9),
            Color(red: 0.5, green: 0.8, blue: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.8)
    static let textAccent = Color(red: 1.0, green: 0.85, blue: 0.0)
    
    static let cardBackground = Color.white.opacity(0.15)
    static let cardBorder = Color.white.opacity(0.3)
}

struct AppDimensions {
    static let cornerRadius: CGFloat = 16
    static let smallCornerRadius: CGFloat = 8
    static let padding: CGFloat = 16
    static let smallPadding: CGFloat = 8
    static let largePadding: CGFloat = 24
    
    static let cardHeight: CGFloat = 200
    static let buttonHeight: CGFloat = 50
    static let iconSize: CGFloat = 24
    static let largeIconSize: CGFloat = 32
}

struct AppFonts {
    static func title(_ size: CGFloat = 24) -> Font {
        return Font.ubuntu(size, weight: .bold)
    }
    
    static func subtitle(_ size: CGFloat = 18) -> Font {
        return Font.ubuntu(size, weight: .medium)
    }
    
    static func body(_ size: CGFloat = 16) -> Font {
        return Font.ubuntu(size, weight: .regular)
    }
    
    static func caption(_ size: CGFloat = 14) -> Font {
        return Font.ubuntu(size, weight: .light)
    }
    
    static func button(_ size: CGFloat = 16) -> Font {
        return Font.ubuntu(size, weight: .medium)
    }
}
