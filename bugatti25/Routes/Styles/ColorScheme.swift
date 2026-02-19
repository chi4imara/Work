import SwiftUI

extension Color {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let primaryWhite = Color.white
    
    static let softPink = Color(red: 0.95, green: 0.7, blue: 0.8)
    static let lightGreen = Color(red: 0.6, green: 0.9, blue: 0.7)
    static let lavender = Color(red: 0.8, green: 0.7, blue: 0.95)
    static let peach = Color(red: 1.0, green: 0.85, blue: 0.7)
    
    static let textPrimary = Color.primaryBlue
    static let textSecondary = Color(red: 0.4, green: 0.4, blue: 0.4)
    static let textLight = Color(red: 0.6, green: 0.6, blue: 0.6)
    
    static let backgroundPrimary = Color.primaryWhite
    static let backgroundSecondary = Color(red: 0.98, green: 0.98, blue: 0.98)
    static let cardBackground = Color.white.opacity(0.9)
    
    static let accentYellow = Color.primaryYellow
    static let accentBlue = Color.primaryBlue
    static let successGreen = Color.lightGreen
    static let warningOrange = Color.peach
}

struct AppColors {
    static let primary = Color.primaryBlue
    static let secondary = Color.primaryYellow
    static let background = Color.backgroundPrimary
    static let cardBackground = Color.cardBackground
    static let text = Color.textPrimary
    static let textSecondary = Color.textSecondary
    static let accent = Color.accentYellow
    static let success = Color.successGreen
}
