import SwiftUI

struct ColorTheme {
    static let primaryBackground = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let secondaryBackground = Color(red: 0.15, green: 0.2, blue: 0.35)
    static let tertiaryBackground = Color(red: 0.2, green: 0.25, blue: 0.4)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let tertiaryText = Color.white.opacity(0.6)
    
    static let primaryAccent = Color(red: 1.0, green: 0.5, blue: 0.0)
    static let secondaryAccent = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let tertiaryAccent = Color(red: 0.9, green: 0.4, blue: 0.0)
    
    static let success = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warning = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let error = Color(red: 1.0, green: 0.3, blue: 0.3)
    
    static let cardBackground = Color.white.opacity(0.1)
    static let cardBorder = Color.white.opacity(0.2)
    
    static let primaryGradient = LinearGradient(
        colors: [primaryBackground, secondaryBackground],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentGradient = LinearGradient(
        colors: [primaryAccent, secondaryAccent],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [cardBackground, cardBackground.opacity(0.5)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

extension View {
    func primaryBackground() -> some View {
        self.background(ColorTheme.primaryGradient)
    }
    
    func cardBackground() -> some View {
        self.background(ColorTheme.cardGradient)
    }
}
