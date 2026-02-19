import SwiftUI

struct ColorTheme {
    static let primaryYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let primaryPink = Color(red: 1.0, green: 0.4, blue: 0.7)
    static let softPink = Color(red: 1.0, green: 0.9, blue: 0.95)
    
    static let backgroundWhite = Color.white
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [backgroundWhite, softPink]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let accentGreen = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let accentPurple = Color(red: 0.6, green: 0.3, blue: 0.9)
    
    static let textPrimary = primaryYellow
    static let textSecondary = Color.black.opacity(0.7)
    static let textTertiary = Color.gray
    
    static let cardBackground = Color.white.opacity(0.9)
    static let buttonBackground = primaryPink
    static let buttonText = Color.white
    static let divider = Color.gray.opacity(0.3)
    
    static let success = accentGreen
    static let warning = Color.orange
    static let error = Color.red
}

struct AppBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
            )
    }
}

extension View {
    func appBackground() -> some View {
        modifier(AppBackgroundModifier())
    }
}
