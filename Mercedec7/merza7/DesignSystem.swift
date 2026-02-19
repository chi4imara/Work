import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let backgroundWhite = Color.white
    
    static let softPink = Color(red: 1.0, green: 0.7, blue: 0.8)
    static let lightGreen = Color(red: 0.7, green: 0.9, blue: 0.7)
    static let lavender = Color(red: 0.8, green: 0.7, blue: 1.0)
    static let peach = Color(red: 1.0, green: 0.8, blue: 0.7)
    
    static let textPrimary = primaryBlue
    static let textSecondary = Color.gray
    static let textLight = Color.white
    
    static let accentYellow = primaryYellow
    static let accentBlue = primaryBlue
    
    static let bubbleColors = [primaryBlue, softPink, lightGreen, lavender, peach]
}

struct AppFonts {
    static func title1() -> Font {
        return .playfairDisplay(size: 32, weight: .bold)
    }
    
    static func title2() -> Font {
        return .playfairDisplay(size: 28, weight: .semibold)
    }
    
    static func title3() -> Font {
        return .playfairDisplay(size: 24, weight: .medium)
    }
    
    static func headline() -> Font {
        return .playfairDisplay(size: 20, weight: .semibold)
    }
    
    static func body() -> Font {
        return .playfairDisplay(size: 16, weight: .regular)
    }
    
    static func bodyMedium() -> Font {
        return .playfairDisplay(size: 16, weight: .medium)
    }
    
    static func caption() -> Font {
        return .playfairDisplay(size: 14, weight: .regular)
    }
    
    static func button() -> Font {
        return .playfairDisplay(size: 16, weight: .semibold)
    }
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
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
}

struct AppShadows {
    static let light = Color.black.opacity(0.1)
    static let medium = Color.black.opacity(0.2)
    static let heavy = Color.black.opacity(0.3)
}
