import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let accentColor = Color(red: 0.5, green: 0.6, blue: 1.0)
    
    static let backgroundGradientStart = Color.white
    static let backgroundGradientEnd = Color(red: 0.9, green: 0.95, blue: 1.0)
    
    static let primaryText = Color.black
    static let secondaryText = Color.gray
    static let lightText = Color(red: 0.6, green: 0.6, blue: 0.6)
    
    static let cardBackground = Color.white.opacity(0.8)
    static let cardShadow = Color.black.opacity(0.1)
    
    static let buttonBackground = primaryBlue
    static let buttonText = Color.white
    static let destructiveButton = Color.red
    
    static let tabBarBackground = Color.white.opacity(0.9)
    static let tabBarSelected = primaryPurple
    static let tabBarUnselected = Color.gray
}

extension LinearGradient {
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.7)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [Color.white.opacity(0.9), Color.white.opacity(0.7)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
