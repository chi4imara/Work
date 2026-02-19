import SwiftUI

struct ColorManager {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let lightBlue = Color(red: 0.85, green: 0.95, blue: 1.0)
    
    static let backgroundGradientStart = Color.white
    static let backgroundGradientEnd = Color(red: 0.95, green: 0.98, blue: 1.0)
    
    static let primaryText = Color(red: 0.1, green: 0.4, blue: 0.8)
    static let secondaryText = Color(red: 0.4, green: 0.4, blue: 0.4)
    static let whiteText = Color.white
    
    static let suitableGreen = Color(red: 0.2, green: 0.7, blue: 0.3)
    static let unsuitableRed = Color(red: 0.9, green: 0.3, blue: 0.3)
    
    static let cardBackground = Color.white.opacity(0.9)
    static let buttonBackground = primaryYellow
    static let buttonSecondary = primaryBlue
    static let tabBarBackground = Color.white.opacity(0.95)
    
    static let backgroundGradient = LinearGradient(
        colors: [backgroundGradientStart, backgroundGradientEnd],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [Color.white, lightBlue.opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [primaryYellow, primaryYellow.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
