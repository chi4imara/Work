import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.3, blue: 0.8)
    static let lightBlue = Color(red: 0.7, green: 0.9, blue: 1.0)
    
    static let backgroundWhite = Color.white
    static let backgroundGray = Color(red: 0.98, green: 0.98, blue: 0.99)
    
    static let primaryText = Color.black
    static let secondaryText = Color.gray
    static let blueText = primaryBlue
    
    static let accent = Color(red: 0.3, green: 0.7, blue: 0.9)
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    
    static let gridBlue = Color(red: 0.8, green: 0.95, blue: 1.0).opacity(0.3)
    static let shadowColor = Color.black.opacity(0.1)
}

extension Color {
    static let appPrimaryBlue = AppColors.primaryBlue
    static let appDarkBlue = AppColors.darkBlue
    static let appLightBlue = AppColors.lightBlue
    static let appBackgroundWhite = AppColors.backgroundWhite
    static let appBackgroundGray = AppColors.backgroundGray
    static let appPrimaryText = AppColors.primaryText
    static let appSecondaryText = AppColors.secondaryText
    static let appBlueText = AppColors.blueText
    static let appAccent = AppColors.accent
    static let appGridBlue = AppColors.gridBlue
    static let appShadow = AppColors.shadowColor
}
