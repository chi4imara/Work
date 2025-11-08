import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let lightBlue = Color(red: 0.6, green: 0.8, blue: 1.0)
    static let darkBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    
    static let yellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let lightYellow = Color(red: 1.0, green: 0.9, blue: 0.4)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let accentText = Color.black
    
    static let cardBackground = Color.white.opacity(0.1)
    static let overlayBackground = Color.black.opacity(0.3)
    
    static let success = Color.green
    static let error = Color.red
    static let warning = Color.orange
}

extension Color {
    static let appPrimaryBlue = AppColors.primaryBlue
    static let appLightBlue = AppColors.lightBlue
    static let appDarkBlue = AppColors.darkBlue
    static let appYellow = AppColors.yellow
    static let appLightYellow = AppColors.lightYellow
    static let appPrimaryText = AppColors.primaryText
    static let appSecondaryText = AppColors.secondaryText
    static let appAccentText = AppColors.accentText
    static let appCardBackground = AppColors.cardBackground
    static let appOverlayBackground = AppColors.overlayBackground
    static let appSuccess = AppColors.success
    static let appError = AppColors.error
    static let appWarning = AppColors.warning
}
