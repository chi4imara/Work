import SwiftUI

struct AppColors {
    static let primary = Color.blue
    static let accent = Color.yellow
    static let background = Color.white
    static let text = Color.blue
    static let textSecondary = Color.gray
    static let cardBackground = Color.white.opacity(0.9)
    static let shadow = Color.black.opacity(0.1)
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
}

extension Color {
    static let appPrimary = AppColors.primary
    static let appAccent = AppColors.accent
    static let appBackground = AppColors.background
    static let appText = AppColors.text
    static let appTextSecondary = AppColors.textSecondary
    static let appCardBackground = AppColors.cardBackground
    static let appShadow = AppColors.shadow
    static let appSuccess = AppColors.success
    static let appWarning = AppColors.warning
    static let appError = AppColors.error
}
