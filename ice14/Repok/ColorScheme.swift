import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.9, blue: 0.3)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryBlue, primaryYellow.opacity(0.6)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.9)
    static let overlayBackground = Color.black.opacity(0.3)
    
    static let primaryText = Color.white
    static let secondaryText = Color.black.opacity(0.7)
    static let accentText = primaryPurple
    
    static let plannedStatus = Color.green.opacity(0.8)
    static let boughtStatus = Color.gray.opacity(0.8)
    
    static let deleteRed = Color.red.opacity(0.8)
    static let editBlue = Color.blue.opacity(0.8)
    static let successGreen = Color.green.opacity(0.8)
}

extension Color {
    static let appPrimary = AppColors.primaryBlue
    static let appSecondary = AppColors.primaryYellow
    static let appAccent = AppColors.primaryPurple
    static let appBackground = AppColors.primaryBlue
    static let appText = AppColors.primaryText
}
