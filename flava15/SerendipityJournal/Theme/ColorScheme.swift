import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let accentTeal = Color(red: 0.2, green: 0.8, blue: 0.8)
    static let softPink = Color(red: 1.0, green: 0.7, blue: 0.8)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color.white,
            Color.white,
            Color(red: 0.4, green: 0.7, blue: 1.0).opacity(0.5)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.9),
            Color(red: 0.98, green: 0.99, blue: 1.0).opacity(0.8)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let primaryText = Color(red: 0.2, green: 0.3, blue: 0.5)
    static let secondaryText = Color(red: 0.4, green: 0.5, blue: 0.7)
    static let lightText = Color(red: 0.6, green: 0.7, blue: 0.8)
    
    static let buttonBackground = primaryPurple
    static let buttonText = Color.white
    static let deleteRed = Color(red: 0.9, green: 0.3, blue: 0.3)
    static let successGreen = Color(red: 0.3, green: 0.8, blue: 0.4)
    
    static let shadowColor = Color.black.opacity(0.1)
    static let cardShadow = Color(red: 0.7, green: 0.8, blue: 0.9).opacity(0.3)
}

extension Color {
    static let theme = AppColors.self
}
