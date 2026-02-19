import SwiftUI

struct AppColors {
    static let darkBlue = Color(red: 0.12, green: 0.16, blue: 0.29)
    static let white = Color.white
    static let lightBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    static let softGray = Color(red: 0.9, green: 0.9, blue: 0.92)
    static let mediumGray = Color(red: 0.6, green: 0.6, blue: 0.65)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.35)
    static let lightPurple = Color(red: 0.7, green: 0.5, blue: 1.0)
    static let softGreen = Color(red: 0.4, green: 0.8, blue: 0.6)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.08, green: 0.12, blue: 0.25),
            Color(red: 0.15, green: 0.20, blue: 0.35),
            Color(red: 0.12, green: 0.16, blue: 0.29)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color(red: 0.18, green: 0.22, blue: 0.35).opacity(0.8),
            Color(red: 0.22, green: 0.26, blue: 0.39).opacity(0.6)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [lightBlue, lightPurple],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let accentGradient = LinearGradient(
        colors: [orange, Color(red: 1.0, green: 0.7, blue: 0.3)],
        startPoint: .leading,
        endPoint: .trailing
    )
}

extension Color {
    static let appDarkBlue = AppColors.darkBlue
    static let appWhite = AppColors.white
    static let appLightBlue = AppColors.lightBlue
    static let appOrange = AppColors.orange
    static let appSoftGray = AppColors.softGray
    static let appMediumGray = AppColors.mediumGray
    static let appDarkGray = AppColors.darkGray
    static let appLightPurple = AppColors.lightPurple
    static let appSoftGreen = AppColors.softGreen
}
