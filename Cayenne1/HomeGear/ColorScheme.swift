import SwiftUI

struct AppColors {
    static let darkBlue = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let deepBlue = Color(red: 0.05, green: 0.1, blue: 0.25)
    static let lightBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let accentText = Color(red: 0.4, green: 0.7, blue: 1.0)
    
    static let backgroundGradient = LinearGradient(
        colors: [darkBlue, deepBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [darkBlue.opacity(0.8), deepBlue.opacity(0.6)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [lightBlue, lightBlue.opacity(0.8)],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let orangeGradient = LinearGradient(
        colors: [orange, orange.opacity(0.8)],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let workingStatus = Color.green
    static let needsCheckStatus = Color.yellow
    static let brokenStatus = Color.red
    
    static let shadowColor = Color.black.opacity(0.3)
    static let borderColor = Color.white.opacity(0.2)
}

extension Color {
    static let appDarkBlue = AppColors.darkBlue
    static let appDeepBlue = AppColors.deepBlue
    static let appLightBlue = AppColors.lightBlue
    static let appOrange = AppColors.orange
    static let appPrimaryText = AppColors.primaryText
    static let appSecondaryText = AppColors.secondaryText
    static let appAccentText = AppColors.accentText
}
