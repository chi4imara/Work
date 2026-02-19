import SwiftUI

struct AppColors {
    static let darkBlue = Color(red: 0.1, green: 0.2, blue: 0.4)
    static let lightBlue = Color(red: 0.3, green: 0.6, blue: 0.9)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    static let primaryBackground = LinearGradient(
        colors: [
            Color(red: 0.05, green: 0.15, blue: 0.35),
            Color(red: 0.15, green: 0.25, blue: 0.45),
            Color(red: 0.1, green: 0.2, blue: 0.4)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color(red: 0.15, green: 0.25, blue: 0.45).opacity(0.8)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let accentText = Color(red: 0.3, green: 0.6, blue: 0.9)
    
    static let successColor = Color.green
    static let warningColor = Color.orange
    static let dangerColor = Color.red
    
    static let normalStock = Color.green
    static let mediumStock = Color.orange
    static let lowStock = Color.red
}

extension Color {
    static let appDarkBlue = AppColors.darkBlue
    static let appLightBlue = AppColors.lightBlue
    static let appOrange = AppColors.orange
    static let appPrimaryText = AppColors.primaryText
    static let appSecondaryText = AppColors.secondaryText
    static let appAccentText = AppColors.accentText
}
