import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let primaryWhite = Color.white
    
    static let lightBlue = Color(red: 0.6, green: 0.8, blue: 1.0)
    static let darkBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    static let softGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let lightYellow = Color(red: 1.0, green: 0.9, blue: 0.6)
    
    static let gradientStart = Color(red: 0.3, green: 0.6, blue: 0.9)
    static let gradientEnd = Color(red: 0.5, green: 0.8, blue: 1.0)
    
    static let primaryText = primaryWhite
    static let secondaryText = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let accentText = accentYellow
    
    static let primaryButton = accentYellow
    static let secondaryButton = lightBlue
    static let disabledButton = softGray
    
    static let cardBackground = Color.white.opacity(0.1)
    static let cardBorder = Color.white.opacity(0.3)
}

extension Color {
    static let theme = AppColors.self
}
