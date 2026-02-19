import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let backgroundWhite = Color.white
    
    static let lightBlue = Color(red: 0.8, green: 0.9, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.3, blue: 0.6)
    static let softGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let textGray = Color(red: 0.4, green: 0.4, blue: 0.4)
    static let accentPink = Color(red: 1.0, green: 0.7, blue: 0.8)
    static let accentGreen = Color(red: 0.7, green: 0.9, blue: 0.7)
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [backgroundWhite, lightBlue]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [backgroundWhite, softGray]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let buttonGradient = LinearGradient(
        gradient: Gradient(colors: [primaryYellow, Color.orange]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let splashGradient = RadialGradient(
        gradient: Gradient(colors: [lightBlue, primaryBlue]),
        center: .center,
        startRadius: 50,
        endRadius: 300
    )
}

extension Color {
    static let appPrimaryBlue = AppColors.primaryBlue
    static let appPrimaryYellow = AppColors.primaryYellow
    static let appBackgroundWhite = AppColors.backgroundWhite
    static let appLightBlue = AppColors.lightBlue
    static let appDarkBlue = AppColors.darkBlue
    static let appSoftGray = AppColors.softGray
    static let appTextGray = AppColors.textGray
    static let appAccentPink = AppColors.accentPink
    static let appAccentGreen = AppColors.accentGreen
}
