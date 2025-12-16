import SwiftUI

struct ColorScheme {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.9, blue: 0.3)
    static let primaryWhite = Color.white
    static let primaryPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    
    static let backgroundBlue = Color(red: 0.5, green: 0.8, blue: 1.0)
    static let backgroundDarkBlue = Color(red: 0.3, green: 0.6, blue: 0.9)
    
    static let accentGreen = Color(red: 0.3, green: 0.8, blue: 0.5)
    static let accentRed = Color(red: 1.0, green: 0.4, blue: 0.4)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let lightGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [backgroundBlue, primaryYellow.opacity(0.3)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [primaryWhite.opacity(0.9), primaryWhite.opacity(0.7)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        gradient: Gradient(colors: [primaryPurple, primaryPurple.opacity(0.8)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    static let theme = ColorScheme.self
}
