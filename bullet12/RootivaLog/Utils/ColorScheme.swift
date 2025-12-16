import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    
    static let backgroundWhite = Color.white
    static let backgroundGradientStart = Color.white
    static let backgroundGradientEnd = Color(red: 0.95, green: 0.95, blue: 1.0)
    
    static let textPrimary = primaryBlue
    static let textSecondary = Color.gray
    static let textTertiary = Color(red: 0.6, green: 0.6, blue: 0.6)
    
    static let accentYellow = primaryYellow
    static let accentPurple = primaryPurple
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    static let success = Color.green
    static let error = Color.red
    static let warning = Color.orange
    
    static let cardBackground = Color.white.opacity(0.9)
    static let surfaceBackground = Color.white.opacity(0.7)
    
    static let orbBlue1 = Color(red: 0.3, green: 0.7, blue: 1.0).opacity(0.6)
    static let orbBlue2 = Color(red: 0.1, green: 0.5, blue: 0.9).opacity(0.4)
    static let orbBlue3 = Color(red: 0.4, green: 0.8, blue: 1.0).opacity(0.5)
}

extension LinearGradient {
    static let appBackground = LinearGradient(
        gradient: Gradient(colors: [AppColors.backgroundGradientStart, AppColors.backgroundGradientEnd]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
