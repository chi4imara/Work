import SwiftUI

struct ColorTheme {
    static let darkBlue = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let lightBlue = Color(red: 0.15, green: 0.25, blue: 0.4)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let white = Color.white
    static let lightGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.3)
    static let accent = Color(red: 0.2, green: 0.7, blue: 1.0)
    
    static let backgroundGradient = LinearGradient(
        colors: [darkBlue, lightBlue, Color(red: 0.2, green: 0.3, blue: 0.5)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.1)
    
    static let primaryText = white
    static let secondaryText = lightGray
    static let accentText = orange
}
