import SwiftUI
import Combine

class ColorManager: ObservableObject {
    static let shared = ColorManager()
    
    private init() {}
    
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.9, blue: 0.3)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let primaryWhite = Color.white
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryBlue, primaryYellow.opacity(0.7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = LinearGradient(
        colors: [Color.white.opacity(0.9), Color.white.opacity(0.7)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let darkCardBackground = LinearGradient(
        colors: [Color.black.opacity(0.3), Color.black.opacity(0.1)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let darkText = Color.black
    static let accentText = primaryPurple
    
    static let buttonBackground = primaryPurple
    static let buttonText = primaryWhite
    static let secondaryButtonBackground = Color.white.opacity(0.2)
    
    static let successColor = Color.green
    static let warningColor = Color.orange
    static let errorColor = Color.red
    static let infoColor = primaryBlue
    
    static let tabBarBackground = Color.black.opacity(0.3)
    static let tabBarSelected = primaryYellow
    static let tabBarUnselected = primaryWhite.opacity(0.6)
    
    static let shadowColor = Color.black.opacity(0.2)
    static let lightShadowColor = Color.black.opacity(0.1)
}

extension Color {
    static let theme = ColorManager.self
}
