import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let primaryWhite = Color.white
    
    static let backgroundBlue = Color(red: 0.3, green: 0.6, blue: 0.9)
    static let backgroundDarkBlue = Color(red: 0.2, green: 0.4, blue: 0.7)
    
    static let accentPink = Color(red: 1.0, green: 0.4, blue: 0.7)
    static let accentGreen = Color(red: 0.4, green: 0.8, blue: 0.6)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.3)
    
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.8)
    static let textTertiary = Color.white.opacity(0.6)
    
    static let cardBackground = Color.white.opacity(0.1)
    static let cardBorder = Color.white.opacity(0.2)
    static let buttonBackground = primaryPurple
    static let buttonText = primaryWhite
    
    static let gridOverlay = Color.white.opacity(0.1)
}

extension Color {
    static let app = AppColors.self
}
