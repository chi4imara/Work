import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 1.0)
    static let primaryWhite = Color.white
    
    static let backgroundGradientStart = Color(red: 0.3, green: 0.6, blue: 0.9)
    static let backgroundGradientEnd = Color(red: 0.5, green: 0.3, blue: 0.8)
    
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.6)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let lightGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    
    static let statusInUse = primaryBlue
    static let statusFavorite = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let statusInRepair = accentOrange
    static let statusLost = Color(red: 0.8, green: 0.2, blue: 0.2)
    
    static let backgroundGradient = LinearGradient(
        colors: [backgroundGradientStart, backgroundGradientEnd],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.15)
    static let cardBorder = Color.white.opacity(0.3)
}

extension Color {
    static func statusColor(for status: AccessoryStatus) -> Color {
        switch status {
        case .inUse:
            return AppColors.statusInUse
        case .favorite:
            return AppColors.statusFavorite
        case .inRepair:
            return AppColors.statusInRepair
        case .lost:
            return AppColors.statusLost
        }
    }
}
