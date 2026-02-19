import SwiftUI

struct AppColors {
    static let backgroundWhite = Color.white
    static let backgroundSecondary = Color(red: 0.97, green: 0.98, blue: 1.0)
    static let primaryBlue = Color(red: 0.2, green: 0.4, blue: 0.85)
    static let secondaryBlue = Color(red: 0.3, green: 0.5, blue: 0.9)
    static let accentYellow = Color(red: 1.0, green: 0.85, blue: 0.2)
    static let textBlue = Color(red: 0.15, green: 0.35, blue: 0.75)
    static let textSecondary = Color(red: 0.2, green: 0.4, blue: 0.8).opacity(0.85)
    static let gridBlue = Color(red: 0.25, green: 0.5, blue: 0.9).opacity(0.35)
    static let cardBackground = Color(red: 0.92, green: 0.95, blue: 1.0)
    static let buttonBackground = Color(red: 0.9, green: 0.94, blue: 1.0)
    static let deleteRed = Color(red: 1.0, green: 0.3, blue: 0.3)
}

extension Color {
    static let appPrimary = AppColors.primaryBlue
    static let appSecondary = AppColors.secondaryBlue
    static let appAccent = AppColors.accentYellow
    static let appTextPrimary = AppColors.textBlue
    static let appTextSecondary = AppColors.textSecondary
    static let appGrid = AppColors.gridBlue
    static let appCard = AppColors.cardBackground
    static let appButton = AppColors.buttonBackground
    static let appDelete = AppColors.deleteRed
    static let appBackground = AppColors.backgroundWhite
    static let appBackgroundSecondary = AppColors.backgroundSecondary
}