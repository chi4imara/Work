import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let lightBlue = Color(red: 0.6, green: 0.8, blue: 1.0)
    static let white = Color.white
    static let purple = Color(red: 0.6, green: 0.4, blue: 0.9)
    
    static let darkPurple = Color(red: 0.4, green: 0.2, blue: 0.7)
    static let lightGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let mediumGray = Color(red: 0.7, green: 0.7, blue: 0.7)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryBlue, lightBlue.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [white.opacity(0.9), white.opacity(0.7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [purple, darkPurple],
        startPoint: .leading,
        endPoint: .trailing
    )
}
