import SwiftUI

struct ColorTheme {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let accentYellow = Color(red: 1.0, green: 0.9, blue: 0.2)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    static let backgroundGradientStart = Color(red: 0.2, green: 0.5, blue: 0.8)
    static let backgroundGradientEnd = Color(red: 0.6, green: 0.8, blue: 1.0)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    
    static let cardBackground = Color.white.opacity(0.15)
    static let buttonBackground = accentOrange
    static let buttonText = Color.white
    
    static let calendarToday = accentYellow
    static let calendarWithEntry = accentOrange
    static let calendarEmpty = Color.white.opacity(0.3)
    
    static let successGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warningRed = Color(red: 1.0, green: 0.3, blue: 0.3)
    
    static let gridPattern = accentYellow.opacity(0.1)
}

extension LinearGradient {
    static let appBackground = LinearGradient(
        gradient: Gradient(colors: [ColorTheme.backgroundGradientStart, ColorTheme.backgroundGradientEnd]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
