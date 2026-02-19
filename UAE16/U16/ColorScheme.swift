import SwiftUI

struct AppColors {
    static let darkBlue = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let white = Color.white
    static let lightBlue = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    static let gray = Color(red: 0.5, green: 0.5, blue: 0.5)
    static let lightGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let green = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let red = Color(red: 0.9, green: 0.3, blue: 0.3)
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.08, green: 0.12, blue: 0.25),
            Color(red: 0.12, green: 0.18, blue: 0.35),
            Color(red: 0.1, green: 0.15, blue: 0.3)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color(red: 0.15, green: 0.2, blue: 0.35).opacity(0.8)
    
    static let primaryButton = lightBlue
    static let secondaryButton = orange
    static let dangerButton = red
}

extension Color {
    static let appDarkBlue = AppColors.darkBlue
    static let appWhite = AppColors.white
    static let appLightBlue = AppColors.lightBlue
    static let appOrange = AppColors.orange
    static let appGray = AppColors.gray
    static let appLightGray = AppColors.lightGray
    static let appDarkGray = AppColors.darkGray
    static let appGreen = AppColors.green
    static let appRed = AppColors.red
    static let appCardBackground = AppColors.cardBackground
}
