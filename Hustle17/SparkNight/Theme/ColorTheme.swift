import SwiftUI

struct ColorTheme {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.4, blue: 0.8)
    static let lightBlue = Color(red: 0.6, green: 0.8, blue: 1.0)
    
    static let backgroundWhite = Color.white
    static let backgroundGray = Color(red: 0.98, green: 0.98, blue: 1.0)
    
    static let textPrimary = Color(red: 0.1, green: 0.4, blue: 0.8)
    static let textSecondary = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let textLight = Color.white
    
    static let accentPink = Color(red: 1.0, green: 0.4, blue: 0.6)
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let accentPurple = Color(red: 0.6, green: 0.4, blue: 1.0)
    
    static let backgroundGradient = LinearGradient(
        colors: [backgroundWhite, backgroundGray],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let blueGradient = LinearGradient(
        colors: [lightBlue, primaryBlue, darkBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [primaryBlue, darkBlue],
        startPoint: .leading,
        endPoint: .trailing
    )
}

extension Color {
    static let theme = ColorTheme.self
}
