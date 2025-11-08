import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let lightBlue = Color(red: 0.6, green: 0.8, blue: 1.0)
    static let darkBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    
    static let backgroundGradientStart = Color(red: 0.3, green: 0.6, blue: 0.9)
    static let backgroundGradientEnd = Color(red: 0.1, green: 0.4, blue: 0.7)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let placeholderText = Color.white.opacity(0.6)
    
    static let cardBackground = Color.white.opacity(0.15)
    static let cardBorder = Color.white.opacity(0.3)
    static let buttonBackground = Color.white.opacity(0.2)
    static let buttonBorder = Color.white.opacity(0.4)
    
    static let accent = Color(red: 1.0, green: 0.8, blue: 0.4)
    static let success = Color(red: 0.4, green: 0.8, blue: 0.4)
    static let warning = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let error = Color(red: 1.0, green: 0.4, blue: 0.4)
    
    static let starColor = Color.white.opacity(0.8)
    
    static let tabBarBackground = Color.black.opacity(0.3)
    static let tabBarSelected = Color.white
    static let tabBarUnselected = Color.white.opacity(0.6)
}
