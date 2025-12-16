import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 1.0)
    static let primaryWhite = Color.white
    
    static let backgroundStart = Color(red: 0.3, green: 0.6, blue: 0.9)
    static let backgroundEnd = Color(red: 0.5, green: 0.3, blue: 0.8)
    
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.8)
    static let textTertiary = Color.white.opacity(0.6)
    
    static let cardBackground = Color.white.opacity(0.15)
    static let cardBorder = Color.white.opacity(0.3)
    
    static let buttonPrimary = primaryPurple
    static let buttonSecondary = Color.white.opacity(0.2)
    static let buttonDestructive = Color.red.opacity(0.8)
    
    static let categoryJoke = Color.yellow.opacity(0.8)
    static let categoryWork = Color.blue.opacity(0.8)
    static let categoryPersonal = Color.green.opacity(0.8)
    static let categoryOther = Color.gray.opacity(0.8)
    
    static let tabBarBackground = Color.black.opacity(0.3)
    static let tabBarSelected = primaryPurple
    static let tabBarUnselected = Color.white.opacity(0.6)
    
    static let particleColor = Color.white.opacity(0.3)
}

extension Color {
    static let theme = AppColors.self
}
