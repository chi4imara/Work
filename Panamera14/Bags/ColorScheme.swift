import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let backgroundWhite = Color.white
    static let lightBlue = Color(red: 0.9, green: 0.95, blue: 1.0)
    
    static let darkBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
    static let softGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let textDark = Color(red: 0.2, green: 0.2, blue: 0.3)
    static let cardBackground = Color(red: 0.98, green: 0.99, blue: 1.0)
    
    static let backgroundGradient = LinearGradient(
        colors: [backgroundWhite, lightBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [cardBackground, Color.white],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    static let appPrimaryBlue = AppColors.primaryBlue
    static let appAccentYellow = AppColors.accentYellow
    static let appBackgroundWhite = AppColors.backgroundWhite
    static let appLightBlue = AppColors.lightBlue
    static let appDarkBlue = AppColors.darkBlue
    static let appSoftGray = AppColors.softGray
    static let appTextDark = AppColors.textDark
    static let appCardBackground = AppColors.cardBackground
}
