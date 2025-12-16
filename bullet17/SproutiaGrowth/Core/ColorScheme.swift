import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let backgroundWhite = Color.white
    
    static let lightBlue = Color(red: 0.7, green: 0.85, blue: 1.0)
    static let softGreen = Color(red: 0.4, green: 0.8, blue: 0.6)
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    
    static let healthyGreen = Color(red: 0.2, green: 0.7, blue: 0.3)
    static let warningOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let alertRed = Color(red: 0.9, green: 0.2, blue: 0.2)
    
    static let primaryText = primaryBlue
    static let secondaryText = Color(red: 0.4, green: 0.4, blue: 0.4)
    static let accentText = primaryYellow
    
    static let backgroundGradient = LinearGradient(
        colors: [backgroundWhite, lightBlue.opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [backgroundWhite, lightGray],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    static let appPrimaryBlue = AppColors.primaryBlue
    static let appPrimaryYellow = AppColors.primaryYellow
    static let appBackgroundWhite = AppColors.backgroundWhite
    static let appLightBlue = AppColors.lightBlue
    static let appSoftGreen = AppColors.softGreen
    static let appLightGray = AppColors.lightGray
    static let appDarkGray = AppColors.darkGray
    static let appHealthyGreen = AppColors.healthyGreen
    static let appWarningOrange = AppColors.warningOrange
    static let appAlertRed = AppColors.alertRed
    static let appPrimaryText = AppColors.primaryText
    static let appSecondaryText = AppColors.secondaryText
    static let appAccentText = AppColors.accentText
}
