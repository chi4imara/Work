import SwiftUI

extension Color {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.3, blue: 0.7)
    static let lightBlue = Color(red: 0.8, green: 0.9, blue: 1.0)
    
    static let backgroundGradientStart = Color(red: 0.95, green: 0.97, blue: 1.0)
    static let backgroundGradientEnd = Color(red: 0.85, green: 0.92, blue: 0.98)
    
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentRed = Color(red: 1.0, green: 0.3, blue: 0.3)
    
    static let textPrimary = Color(red: 0.1, green: 0.1, blue: 0.2)
    static let textSecondary = Color(red: 0.4, green: 0.4, blue: 0.5)
    static let textLight = Color.white
    
    static let cardBackground = Color.white.opacity(0.9)
    static let cardShadow = Color.black.opacity(0.1)
}

struct AppColors {
    static let primary = Color.primaryBlue
    static let secondary = Color.darkBlue
    static let accent = Color.accentOrange
    static let background = LinearGradient(
        colors: [Color.backgroundGradientStart, Color.backgroundGradientEnd],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let cardBackground = Color.cardBackground
    static let textPrimary = Color.textPrimary
    static let textSecondary = Color.textSecondary
}

