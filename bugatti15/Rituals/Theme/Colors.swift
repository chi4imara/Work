import SwiftUI

struct AppColors {
    static let primary = Color(red: 0.4, green: 0.8, blue: 1.0)
    static let secondary = Color(red: 1.0, green: 0.9, blue: 0.2)
    static let background = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 0.3, green: 0.7, blue: 0.9),
            Color(red: 0.5, green: 0.8, blue: 1.0),
            Color(red: 0.4, green: 0.6, blue: 0.8)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    static let white = Color.white
    static let cardBackground = Color.white.opacity(0.2)
    static let accent = Color(red: 1.0, green: 0.6, blue: 0.8)
    static let success = Color(red: 0.3, green: 0.8, blue: 0.4)
    static let warning = Color(red: 1.0, green: 0.7, blue: 0.3)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.8)
    static let shadow = Color.black.opacity(0.1)
}

struct AppGradients {
    static let primaryCard = LinearGradient(
        gradient: Gradient(colors: [
            AppColors.white.opacity(0.3),
            AppColors.white.opacity(0.1)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let button = LinearGradient(
        gradient: Gradient(colors: [
            AppColors.secondary,
            AppColors.secondary.opacity(0.8)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let tabBar = LinearGradient(
        gradient: Gradient(colors: [
            AppColors.white.opacity(0.2),
            AppColors.white.opacity(0.1)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
}
