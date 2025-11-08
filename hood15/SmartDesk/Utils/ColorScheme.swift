import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let secondaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let lightBlue = Color(red: 0.8, green: 0.9, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.3, blue: 0.8)
    static let background = Color.white
    static let cardBackground = Color(red: 0.98, green: 0.99, blue: 1.0)
    static let textPrimary = AppColors.darkBlue
    static let textSecondary = Color.gray
    static let accent = Color(red: 0.9, green: 0.4, blue: 0.6)
    static let success = Color.green
    static let warning = Color.orange
}

extension Color {
    static let appPrimary = AppColors.primaryBlue
    static let appSecondary = AppColors.secondaryBlue
    static let appBackground = AppColors.background
    static let appText = AppColors.textPrimary
}
