import SwiftUI

extension Color {
    static let primaryBackground = Color.white
    static let primaryText = Color(red: 0.2, green: 0.6, blue: 0.9)
    static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let secondaryText = Color.gray
    static let cardBackground = Color.white.opacity(0.9)
    
    static let gradientPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let gradientBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let gradientPink = Color(red: 0.9, green: 0.5, blue: 0.8)
    
    static let softGreen = Color(red: 0.5, green: 0.8, blue: 0.6)
    static let lightOrange = Color(red: 1.0, green: 0.7, blue: 0.4)
    static let lavender = Color(red: 0.8, green: 0.7, blue: 0.9)
    
    static let errorRed = Color.red
    static let successGreen = Color.green
}

struct AppGradients {
    static let backgroundGradient = LinearGradient(
        colors: [Color.primaryBackground, Color.gradientPurple.opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [Color.cardBackground, Color.gradientBlue.opacity(0.1)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let buttonGradient = LinearGradient(
        colors: [Color.accentYellow, Color.lightOrange],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let splashGradient = LinearGradient(
        colors: [Color.gradientPurple, Color.gradientBlue, Color.gradientPink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
