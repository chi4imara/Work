import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.1, green: 0.2, blue: 0.4)
    static let darkBlue = Color(red: 0.05, green: 0.1, blue: 0.25)
    static let lightBlue = Color(red: 0.2, green: 0.3, blue: 0.5)
    
    static let primaryOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let lightOrange = Color(red: 1.0, green: 0.7, blue: 0.4)
    static let darkOrange = Color(red: 0.9, green: 0.5, blue: 0.1)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let tertiaryText = Color.white.opacity(0.6)
    
    static let success = Color.green
    static let warning = Color.yellow
    static let error = Color.red
    static let cardBackground = Color.white.opacity(0.1)
    static let separatorColor = Color.white.opacity(0.2)
    
    static let backgroundGradient = LinearGradient(
        colors: [darkBlue, primaryBlue, lightBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [Color.white.opacity(0.15), Color.white.opacity(0.05)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [primaryOrange, darkOrange],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
