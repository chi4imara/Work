import SwiftUI

struct ColorTheme {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let backgroundWhite = Color.white
    
    static let lightBlue = Color(red: 0.7, green: 0.9, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.3, blue: 0.6)
    static let softGray = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let textGray = Color(red: 0.4, green: 0.4, blue: 0.4)
    
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 0.9)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    static let backgroundGradient = LinearGradient(
        colors: [backgroundWhite, lightBlue.opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [backgroundWhite, softGray],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let categoryColors: [Color] = [
        primaryBlue,
        accentGreen,
        accentPurple,
        accentOrange,
        primaryYellow,
        Color.pink,
        Color.teal,
        Color.indigo
    ]
}

extension Color {
    static let theme = ColorTheme.self
}
