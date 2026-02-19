import SwiftUI

struct ColorManager {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let primaryWhite = Color.white
    
    static let softPink = Color(red: 1.0, green: 0.7, blue: 0.8)
    static let lightGreen = Color(red: 0.7, green: 0.9, blue: 0.7)
    static let lavender = Color(red: 0.8, green: 0.7, blue: 1.0)
    static let peach = Color(red: 1.0, green: 0.8, blue: 0.7)
    
    static let primaryText = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let secondaryText = Color(red: 0.4, green: 0.4, blue: 0.4)
    static let darkText = Color(red: 0.2, green: 0.2, blue: 0.2)
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.95, green: 0.97, blue: 1.0),
            Color(red: 0.98, green: 0.95, blue: 0.98),
            Color(red: 1.0, green: 0.98, blue: 0.95)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 0.8)
    static let shadowColor = Color.black.opacity(0.1)
    
    static let successGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warningOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let errorRed = Color(red: 1.0, green: 0.3, blue: 0.3)
    
    static let tabBarBackground = Color.white.opacity(0.95)
    static let tabBarSelected = primaryBlue
    static let tabBarUnselected = Color.gray.opacity(0.6)
}

extension Color {
    static let theme = ColorManager.self
}
