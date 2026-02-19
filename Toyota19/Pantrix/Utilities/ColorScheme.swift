import SwiftUI

struct AppColors {
    static let darkBlue = Color(red: 0.1, green: 0.2, blue: 0.4)
    static let primaryOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let white = Color.white
    
    static let lightGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let mediumGray = Color(red: 0.6, green: 0.6, blue: 0.6)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let lightBlue = Color(red: 0.4, green: 0.6, blue: 0.8)
    static let green = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let red = Color(red: 0.9, green: 0.3, blue: 0.3)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.05, green: 0.15, blue: 0.35),
            Color(red: 0.15, green: 0.25, blue: 0.45),
            Color(red: 0.1, green: 0.2, blue: 0.4)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.1),
            Color.white.opacity(0.05)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    static let appDarkBlue = AppColors.darkBlue
    static let appOrange = AppColors.primaryOrange
    static let appWhite = AppColors.white
    static let appLightGray = AppColors.lightGray
    static let appMediumGray = AppColors.mediumGray
    static let appDarkGray = AppColors.darkGray
    static let appLightBlue = AppColors.lightBlue
    static let appGreen = AppColors.green
    static let appRed = AppColors.red
}
