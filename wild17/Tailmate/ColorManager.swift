import SwiftUI

class ColorManager {
    static let shared = ColorManager()
    
    private init() {}
    
    let backgroundBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    let backgroundGradientStart = Color(red: 0.3, green: 0.6, blue: 0.9)
    let backgroundGradientEnd = Color(red: 0.5, green: 0.8, blue: 1.0)
    
    let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    let secondaryPurple = Color(red: 0.7, green: 0.5, blue: 1.0)
    
    let textWhite = Color.white
    let textSecondary = Color.white.opacity(0.8)
    
    let accentGreen = Color(red: 0.3, green: 0.8, blue: 0.5)
    let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    let accentRed = Color(red: 1.0, green: 0.3, blue: 0.3)
    let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    
    let cardBackground = Color.white.opacity(0.15)
    let cardBorder = Color.white.opacity(0.3)
    
    let buttonPrimary = Color(red: 0.6, green: 0.4, blue: 0.9)
    let buttonSecondary = Color.white.opacity(0.2)
    let buttonDisabled = Color.gray.opacity(0.3)
    
    var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [backgroundGradientStart, backgroundGradientEnd]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var cardGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [cardBackground, cardBackground.opacity(0.8)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

extension Color {
    static let theme = ColorManager.shared
}
