import SwiftUI

struct ColorTheme {
    static let darkBlue = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let lightBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let white = Color.white
    
    static let accent = Color(red: 0.2, green: 0.8, blue: 0.9)
    static let secondary = Color(red: 0.6, green: 0.8, blue: 1.0)
    static let cardBackground = Color(red: 0.15, green: 0.2, blue: 0.35)
    static let textSecondary = Color(red: 0.7, green: 0.8, blue: 0.9)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.05, green: 0.1, blue: 0.25),
            Color(red: 0.15, green: 0.2, blue: 0.4),
            Color(red: 0.1, green: 0.15, blue: 0.3)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color(red: 0.2, green: 0.25, blue: 0.4),
            Color(red: 0.15, green: 0.2, blue: 0.35)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [
            Color(red: 0.3, green: 0.6, blue: 0.9),
            Color(red: 0.2, green: 0.5, blue: 0.8)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension View {
    func backgroundGradient() -> some View {
        self.background(ColorTheme.backgroundGradient.ignoresSafeArea())
    }
}
