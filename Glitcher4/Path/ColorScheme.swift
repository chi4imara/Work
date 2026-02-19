import SwiftUI

struct AppColors {
    static let darkBlue = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let lightBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let white = Color.white
    
    static let gray = Color(red: 0.5, green: 0.5, blue: 0.5)
    static let lightGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let green = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let red = Color(red: 1.0, green: 0.3, blue: 0.3)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.05, green: 0.1, blue: 0.25),
            Color(red: 0.15, green: 0.2, blue: 0.35),
            Color(red: 0.1, green: 0.15, blue: 0.3)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color(red: 0.2, green: 0.25, blue: 0.4).opacity(0.8),
            Color(red: 0.15, green: 0.2, blue: 0.35).opacity(0.6)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    static let appDarkBlue = AppColors.darkBlue
    static let appLightBlue = AppColors.lightBlue
    static let appOrange = AppColors.orange
    static let appWhite = AppColors.white
    static let appGray = AppColors.gray
    static let appLightGray = AppColors.lightGray
    static let appGreen = AppColors.green
    static let appRed = AppColors.red
}
