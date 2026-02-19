import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let lightBlue = Color(red: 0.6, green: 0.8, blue: 1.0)
    static let darkBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    
    static let accent = Color.yellow
    static let accentSecondary = Color(red: 1.0, green: 0.8, blue: 0.0)
    
    static let softPink = Color(red: 1.0, green: 0.7, blue: 0.8)
    static let lightGreen = Color(red: 0.7, green: 1.0, blue: 0.8)
    static let lavender = Color(red: 0.8, green: 0.7, blue: 1.0)
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryBlue, lightBlue, darkBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.1)
    static let cardBorder = Color.white.opacity(0.2)
    
    static let buttonBackground = accent
    static let buttonText = Color.black
    static let secondaryButtonBackground = Color.white.opacity(0.2)
    
    static let tabBarBackground = Color.white.opacity(0.1)
    static let tabBarSelected = accent
    static let tabBarUnselected = Color.white.opacity(0.6)
}
