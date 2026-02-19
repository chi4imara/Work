import SwiftUI

struct AppColors {
    static let darkBlue = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let deepBlue = Color(red: 0.05, green: 0.1, blue: 0.25)
    static let lightBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let accentText = Color(red: 0.4, green: 0.7, blue: 1.0)
    
    static let primaryBackground = darkBlue
    static let secondaryBackground = deepBlue
    static let cardBackground = Color.white.opacity(0.1)
    
    static let primaryButton = lightBlue
    static let secondaryButton = orange
    static let destructiveButton = Color.red.opacity(0.8)
    
    static let success = Color.green.opacity(0.8)
    static let warning = Color.yellow.opacity(0.8)
    static let border = Color.white.opacity(0.2)
}

extension Color {
    static let appDarkBlue = AppColors.darkBlue
    static let appDeepBlue = AppColors.deepBlue
    static let appLightBlue = AppColors.lightBlue
    static let appOrange = AppColors.orange
    static let appPrimaryText = AppColors.primaryText
    static let appSecondaryText = AppColors.secondaryText
    static let appAccentText = AppColors.accentText
    static let appPrimaryBackground = AppColors.primaryBackground
    static let appSecondaryBackground = AppColors.secondaryBackground
    static let appCardBackground = AppColors.cardBackground
    static let appPrimaryButton = AppColors.primaryButton
    static let appSecondaryButton = AppColors.secondaryButton
    static let appDestructiveButton = AppColors.destructiveButton
    static let appSuccess = AppColors.success
    static let appWarning = AppColors.warning
    static let appBorder = AppColors.border
}
