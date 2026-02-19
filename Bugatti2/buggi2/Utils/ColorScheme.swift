import SwiftUI

struct AppColors {
    static let backgroundBlue = Color(red: 0.35, green: 0.65, blue: 0.95)
    static let gridWhite = Color.white.opacity(0.22)
    static let primaryTextWhite = Color.white
    static let secondaryTextWhite = Color.white.opacity(0.9)

    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let backgroundWhite = Color.white

    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.95)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 0.8)
    static let softOrange = Color(red: 1.0, green: 0.6, blue: 0.3)

    static let gridBlue = Color(red: 0.8, green: 0.9, blue: 1.0).opacity(0.3)
    static let cardBackground = Color.white.opacity(0.2)
    static let shadowColor = Color.black.opacity(0.15)
}

extension Color {
    static let appPrimary = AppColors.primaryBlue
    static let appSecondary = AppColors.primaryYellow
    static let appBackground = AppColors.backgroundBlue
    static let appText = AppColors.primaryTextWhite
    static let appAccent = AppColors.accentGreen
}
