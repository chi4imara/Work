import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let secondaryBlue = Color(red: 0.6, green: 0.8, blue: 1.0)
    static let accentPurple = Color(red: 0.7, green: 0.5, blue: 1.0)
    static let softPink = Color(red: 1.0, green: 0.7, blue: 0.8)
    
    static let backgroundGradientStart = Color(red: 0.98, green: 0.99, blue: 1.0)
    static let backgroundGradientEnd = Color(red: 0.95, green: 0.97, blue: 1.0)
    
    static let cardBackground = Color.white.opacity(0.9)
    static let cardShadow = Color.black.opacity(0.1)
    
    static let primaryText = Color(red: 0.2, green: 0.2, blue: 0.3)
    static let secondaryText = Color(red: 0.5, green: 0.5, blue: 0.6)
    static let lightText = Color.white
    
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    
    static let tabBarBackground = Color.white.opacity(0.95)
    static let tabBarSelected = primaryBlue
    static let tabBarUnselected = Color.gray
}

extension Color {
    static let appPrimary = AppColors.primaryBlue
    static let appSecondary = AppColors.secondaryBlue
    static let appAccent = AppColors.accentPurple
    static let appBackground = AppColors.backgroundGradientStart
    static let appText = AppColors.primaryText
    static let appSecondaryText = AppColors.secondaryText
}
