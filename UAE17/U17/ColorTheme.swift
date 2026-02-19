import SwiftUI

struct ColorTheme {
    static let darkBlue = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let white = Color.white
    static let lightBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    static let gray = Color(red: 0.5, green: 0.5, blue: 0.5)
    static let lightGray = Color(red: 0.9, green: 0.9, blue: 0.9)
    static let darkGray = Color(red: 0.2, green: 0.2, blue: 0.2)
    static let green = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let red = Color(red: 1.0, green: 0.3, blue: 0.3)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            darkBlue,
            Color(red: 0.15, green: 0.2, blue: 0.4),
            Color(red: 0.2, green: 0.25, blue: 0.5)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color(red: 0.2, green: 0.25, blue: 0.4).opacity(0.8),
            Color(red: 0.15, green: 0.2, blue: 0.35).opacity(0.9)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension Color {
    static let theme = ColorTheme.self
}
