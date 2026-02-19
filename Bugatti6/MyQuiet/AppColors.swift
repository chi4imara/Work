import SwiftUI

struct AppColors {
    static let background = Color.white
    static let gridBlue = Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.3)
    static let textBlue = Color(red: 0.2, green: 0.5, blue: 0.9)
    static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let softPurple = Color(red: 0.7, green: 0.6, blue: 0.9, opacity: 0.8)
    static let lightOrange = Color(red: 1.0, green: 0.7, blue: 0.4, opacity: 0.6)
    static let errorRed = Color(red: 0.9, green: 0.2, blue: 0.2)
    static let successGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [background, lightGray]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        gradient: Gradient(colors: [accentYellow, lightOrange]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [Color.white, lightGray]),
        startPoint: .top,
        endPoint: .bottom
    )
}

extension Color {
    static let appBackground = AppColors.background
    static let appGridBlue = AppColors.gridBlue
    static let appTextBlue = AppColors.textBlue
    static let appAccentYellow = AppColors.accentYellow
    static let appLightGray = AppColors.lightGray
    static let appDarkGray = AppColors.darkGray
    static let appSoftPurple = AppColors.softPurple
    static let appLightOrange = AppColors.lightOrange
    static let appErrorRed = AppColors.errorRed
    static let appSuccessGreen = AppColors.successGreen
}
