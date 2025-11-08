import SwiftUI

struct AppColors {
    static let background = Color(red: 0.189, green: 0.701, blue: 0.959)
    static let primary = Color(red: 0.1, green: 0.2, blue: 0.4)
    static let secondary = Color.black
    
    static let accent = Color(red: 0.2, green: 0.6, blue: 0.3)
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.95)
    static let mediumGray = Color.black.opacity(0.6)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    
    static let success = Color(red: 0.2, green: 0.7, blue: 0.3)
    static let warning = Color(red: 1.0, green: 0.6, blue: 0.0)
    static let error = Color(red: 0.8, green: 0.2, blue: 0.2)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.95, green: 0.98, blue: 1.0),
            Color(red: 0.9, green: 0.95, blue: 1.0),
            Color(red: 0.85, green: 0.92, blue: 0.98),
            Color(red: 0.8, green: 0.88, blue: 0.95)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let universalGradient = LinearGradient(
        colors: [
            Color(red: 0.189, green: 0.701, blue: 0.959),
            Color(red: 0.189, green: 0.701, blue: 0.959).opacity(0.8),
            Color(red: 0.189, green: 0.701, blue: 0.959).opacity(0.6),
            Color(red: 0.189, green: 0.701, blue: 0.959).opacity(0.4)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    static let appPrimary = AppColors.primary
    static let appSecondary = AppColors.secondary
    static let appAccent = AppColors.accent
    static let appBackground = AppColors.background
    static let appLightGray = AppColors.lightGray
    static let appMediumGray = AppColors.mediumGray
    static let appDarkGray = AppColors.darkGray
    static let appSuccess = AppColors.success
    static let appWarning = AppColors.warning
    static let appError = AppColors.error
}
