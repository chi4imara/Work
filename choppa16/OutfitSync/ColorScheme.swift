import SwiftUI

extension Color {
    static let primaryPurple = Color(red: 0.5, green: 0.3, blue: 0.8)
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let primaryWhite = Color.white
    
    static let gradientStart = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let gradientEnd = Color(red: 0.4, green: 0.2, blue: 0.7)
    
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentOrange = Color(red: 1.0, green: 0.5, blue: 0.2)
    static let softGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    
    static let textPrimary = Color.black
    static let textSecondary = Color(red: 0.4, green: 0.4, blue: 0.4)
    static let textOnDark = Color.white
    
    static let backgroundPrimary = Color.white
    static let backgroundSecondary = Color(red: 0.98, green: 0.98, blue: 0.98)
    static let cardBackground = Color.white.opacity(0.9)
}

struct AppGradients {
    static let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [Color.gradientStart, Color.gradientEnd]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color.primaryWhite, Color.softGray]),
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [Color.cardBackground, Color.primaryWhite]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct AppShadows {
    static let cardShadow = Color.black.opacity(0.1)
    static let buttonShadow = Color.black.opacity(0.2)
}
