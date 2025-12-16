import SwiftUI

struct ColorManager {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let white = Color.white
    
    static let backgroundGradientStart = Color.white
    static let backgroundGradientEnd = Color(red: 0.9, green: 0.95, blue: 1.0)
    
    static let primaryText = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let secondaryText = Color.gray
    static let whiteText = Color.white
    
    static let cardBackground = Color.white.opacity(0.9)
    static let shadowColor = Color.black.opacity(0.1)
    static let accentColor = Color(red: 0.0, green: 0.8, blue: 0.4)
    static let errorColor = Color.red
    static let warningColor = Color.orange
    
    static let mainGradient = LinearGradient(
        gradient: Gradient(colors: [backgroundGradientStart, backgroundGradientEnd]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [cardBackground, cardBackground.opacity(0.7)]),
        startPoint: .top,
        endPoint: .bottom
    )
}
