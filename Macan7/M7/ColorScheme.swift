import SwiftUI

struct AppColors {
    static let background = Color.white
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    
    static let lightBlue = Color(red: 0.7, green: 0.9, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.3, blue: 0.6)
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.95)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let green = Color(red: 0.2, green: 0.8, blue: 0.2)
    
    static let planned = Color(red: 0.2, green: 0.8, blue: 0.2)
    static let completed = Color(red: 0.6, green: 0.6, blue: 0.6)
    
    static let primaryText = primaryBlue
    static let secondaryText = darkGray
    static let accentText = primaryYellow
}

extension Color {
    static let appBackground = AppColors.background
    static let appPrimary = AppColors.primaryBlue
    static let appYellow = AppColors.primaryYellow
    static let appLightBlue = AppColors.lightBlue
    static let appDarkBlue = AppColors.darkBlue
    static let appLightGray = AppColors.lightGray
    static let appDarkGray = AppColors.darkGray
    static let appGreen = AppColors.green
    static let appPlanned = AppColors.planned
    static let appCompleted = AppColors.completed
    static let appPrimaryText = AppColors.primaryText
    static let appSecondaryText = AppColors.secondaryText
    static let appAccentText = AppColors.accentText
}
