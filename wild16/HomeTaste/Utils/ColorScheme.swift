import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let backgroundWhite = Color.white
    
    static let lightBlue = Color(red: 0.85, green: 0.95, blue: 1.0)
    static let mediumBlue = Color(red: 0.7, green: 0.85, blue: 1.0)
    
    static let textPrimary = Color(red: 0.2, green: 0.5, blue: 0.8)
    static let textSecondary = Color(red: 0.4, green: 0.4, blue: 0.4)
    static let accent = Color(red: 1.0, green: 0.6, blue: 0.0)
    static let success = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warning = Color(red: 1.0, green: 0.4, blue: 0.4)
    
    static let backgroundGradient = LinearGradient(
        colors: [backgroundWhite, lightBlue, mediumBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [backgroundWhite.opacity(0.9), lightBlue.opacity(0.7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
