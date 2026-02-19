import SwiftUI

struct ColorTheme {
    static let primaryPink = Color(red: 1.0, green: 0.4, blue: 0.7)
    static let primaryYellow = Color(red: 1.0, green: 0.9, blue: 0.3)
    static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    
    static let backgroundGradient = LinearGradient(
        colors: [primaryPink, primaryYellow.opacity(0.3)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.1)
    static let cardBorder = Color.white.opacity(0.2)
    
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
    static let info = Color.blue
    
    static let tabBarBackground = Color.black.opacity(0.2)
    static let tabBarSelected = accentYellow
    static let tabBarUnselected = Color.white.opacity(0.6)
}

extension View {
    func primaryBackground() -> some View {
        self.background(ColorTheme.backgroundGradient.ignoresSafeArea())
    }
    
    func cardStyle() -> some View {
        self
            .background(ColorTheme.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(ColorTheme.cardBorder, lineWidth: 1)
            )
            .cornerRadius(12)
    }
}
