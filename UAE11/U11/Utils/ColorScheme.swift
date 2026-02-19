import SwiftUI

struct AppColors {
    static let primaryBackground = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let secondaryBackground = Color(red: 0.15, green: 0.2, blue: 0.35)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    
    static let lightBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let purple = Color(red: 0.7, green: 0.4, blue: 1.0)
    static let green = Color(red: 0.3, green: 0.8, blue: 0.5)
    static let pink = Color(red: 1.0, green: 0.4, blue: 0.7)
    
    static let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.1, green: 0.15, blue: 0.3),
            Color(red: 0.05, green: 0.1, blue: 0.25),
            Color(red: 0.15, green: 0.2, blue: 0.35)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.2, green: 0.25, blue: 0.4).opacity(0.8),
            Color(red: 0.15, green: 0.2, blue: 0.35).opacity(0.6)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let primaryButton = lightBlue
    static let secondaryButton = orange
    static let dangerButton = Color.red
}

extension Color {
    static let appPrimary = AppColors.primaryBackground
    static let appSecondary = AppColors.secondaryBackground
    static let appText = AppColors.primaryText
    static let appAccent = AppColors.lightBlue
}
