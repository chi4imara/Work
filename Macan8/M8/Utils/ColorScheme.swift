import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let lightBlue = Color(red: 0.6, green: 0.8, blue: 1.0)
    static let darkBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    
    static let accentYellow = Color(red: 1.0, green: 0.9, blue: 0.2)
    static let brightYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    
    static let backgroundGradientStart = Color(red: 0.3, green: 0.6, blue: 0.9)
    static let backgroundGradientEnd = Color(red: 0.5, green: 0.8, blue: 1.0)
    
    static let cardBackground = Color.white.opacity(0.1)
    static let cardBorder = Color.white.opacity(0.2)
    
    static let gridColor = Color.white.opacity(0.1)
}

extension Color {
    static let appPrimary = AppColors.primaryBlue
    static let appAccent = AppColors.accentYellow
    static let appText = AppColors.primaryText
    static let appSecondaryText = AppColors.secondaryText
    static let appBackground = AppColors.backgroundGradientStart
}
