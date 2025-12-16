import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.8)
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryBlue, primaryYellow.opacity(0.6)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.9)
    static let overlayBackground = Color.black.opacity(0.3)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let darkText = Color.black
    
    static let accent = primaryPurple
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    
    static let buttonPrimary = primaryPurple
    static let buttonSecondary = Color.white.opacity(0.2)
    
    static let tabBarBackground = Color.white.opacity(0.1)
    static let tabBarSelected = primaryYellow
    static let tabBarUnselected = Color.white.opacity(0.6)
}
