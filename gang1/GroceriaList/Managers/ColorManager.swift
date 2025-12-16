import SwiftUI

struct ColorManager {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let primaryWhite = Color.white
    
    static let backgroundGradientStart = Color(red: 0.1, green: 0.5, blue: 0.9)
    static let backgroundGradientEnd = Color(red: 0.3, green: 0.7, blue: 1.0)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let accentText = ColorManager.primaryYellow
    
    static let cardBackground = Color.white.opacity(0.9)
    static let cardBackgroundCompleted = Color.gray.opacity(0.3)
    
    static let buttonPrimary = ColorManager.primaryYellow
    static let buttonSecondary = Color.white.opacity(0.2)
    static let buttonDanger = Color.red.opacity(0.8)
    
    static let accent = Color(red: 0.9, green: 0.3, blue: 0.5)
    static let success = Color.green.opacity(0.8)
    static let warning = Color.orange.opacity(0.8)
    
    static let orbColors = [
        Color.white.opacity(0.3),
        Color.white.opacity(0.2),
        Color.white.opacity(0.4),
        ColorManager.primaryYellow.opacity(0.3),
        ColorManager.accent.opacity(0.3)
    ]
}
