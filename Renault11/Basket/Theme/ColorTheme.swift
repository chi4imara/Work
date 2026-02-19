import SwiftUI

struct ColorTheme {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 0.9)
    static let lightBlue = Color(red: 0.6, green: 0.8, blue: 0.95)
    static let darkBlue = Color(red: 0.2, green: 0.5, blue: 0.8)
    
    static let primaryYellow = Color(red: 1.0, green: 0.85, blue: 0.0)
    static let lightYellow = Color(red: 1.0, green: 0.95, blue: 0.6)
    static let darkYellow = Color(red: 0.9, green: 0.7, blue: 0.0)
    
    static let primaryWhite = Color.white
    static let lightGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    
    static let softPink = Color(red: 1.0, green: 0.8, blue: 0.9)
    static let lightGreen = Color(red: 0.7, green: 0.9, blue: 0.7)
    static let softPurple = Color(red: 0.8, green: 0.7, blue: 0.9)
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [primaryBlue, lightBlue, Color(red: 0.5, green: 0.75, blue: 0.92)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [primaryWhite.opacity(0.2), primaryWhite.opacity(0.1)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    static let theme = ColorTheme.self
}
