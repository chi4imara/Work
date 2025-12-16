import SwiftUI

struct ColorManager {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryBlue, primaryYellow],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.9)
    static let overlayBackground = Color.black.opacity(0.3)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let darkText = Color.black
    static let grayText = Color.gray
    
    static let accentPurple = primaryPurple
    static let favoriteHeart = Color.red
    static let successGreen = Color.green
    static let warningOrange = Color.orange
    
    static let buttonPrimary = primaryPurple
    static let buttonSecondary = Color.white.opacity(0.2)
    static let buttonDestructive = Color.red
    
    static let tabBarBackground = Color.white.opacity(0.25)
    static let tabBarSelected = primaryYellow
    static let tabBarUnselected = Color.white.opacity(0.7)
}

extension Color {
    static let theme = ColorManager.self
}
