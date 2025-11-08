import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let secondaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let lightBlue = Color(red: 0.8, green: 0.9, blue: 1.0)
    
    static let backgroundGradientStart = Color.white
    static let backgroundGradientEnd = Color(red: 0.032, green: 0.711, blue: 1)
    
    static let primaryText = Color(red: 0.1, green: 0.1, blue: 0.2)
    static let secondaryText = Color(red: 0.4, green: 0.4, blue: 0.6)
    static let blueText = Color(red: 0.2, green: 0.5, blue: 0.9)
    
    static let cardBackground = Color.white.opacity(0.8)
    static let cardBorder = Color(red: 0.9, green: 0.95, blue: 1.0)
    
    static let accent = Color(red: 0.3, green: 0.6, blue: 0.9)
    static let success = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warning = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let error = Color(red: 0.9, green: 0.3, blue: 0.3)
}

extension LinearGradient {
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [AppColors.backgroundGradientStart, AppColors.backgroundGradientEnd]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [AppColors.cardBackground, AppColors.cardBackground.opacity(0.6)]),
        startPoint: .top,
        endPoint: .bottom
    )
}
