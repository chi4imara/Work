import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    static let backgroundWhite = Color.white
    
    static let lightBlue = Color(red: 0.8, green: 0.9, blue: 1.0)
    static let mediumBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    
    static let textPrimary = Color(red: 0.1, green: 0.1, blue: 0.1)
    static let textSecondary = Color(red: 0.4, green: 0.4, blue: 0.4)
    static let cardBackground = Color(red: 0.98, green: 0.99, blue: 1.0)
    static let shadowColor = Color.black.opacity(0.1)
    
    static let backgroundGradient = LinearGradient(
        colors: [backgroundWhite, lightBlue, mediumBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [cardBackground, backgroundWhite],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
