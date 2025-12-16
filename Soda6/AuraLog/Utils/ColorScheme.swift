import SwiftUI

extension Color {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.8)
    
    static let backgroundGradientStart = Color(red: 0.3, green: 0.6, blue: 0.9)
    static let backgroundGradientEnd = Color(red: 0.5, green: 0.8, blue: 1.0)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let accentPink = Color(red: 1.0, green: 0.4, blue: 0.6)
    static let accentGreen = Color(red: 0.4, green: 0.8, blue: 0.4)
    
    static let cardBackground = Color.white.opacity(0.15)
    static let surfaceBackground = Color.white.opacity(0.1)
}

struct AppGradients {
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color.backgroundGradientStart, Color.backgroundGradientEnd]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [Color.cardBackground, Color.surfaceBackground]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let yellowGradient = LinearGradient(
        gradient: Gradient(colors: [Color.primaryYellow, Color.accentOrange]),
        startPoint: .leading,
        endPoint: .trailing
    )
}
