import SwiftUI

struct ColorTheme {
    static let primaryBackground = Color(red: 0.1, green: 0.15, blue: 0.3)
    static let secondaryBackground = Color(red: 0.15, green: 0.2, blue: 0.35)
    static let tertiaryBackground = Color(red: 0.2, green: 0.25, blue: 0.4)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let tertiaryText = Color.white.opacity(0.6)
    
    static let lightBlue = Color(red: 0.3, green: 0.7, blue: 1.0)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    static let green = Color(red: 0.3, green: 0.8, blue: 0.4)
    static let red = Color(red: 1.0, green: 0.3, blue: 0.3)
    static let yellow = Color(red: 1.0, green: 0.8, blue: 0.2)
    
    static let inUse = lightBlue
    static let runningOut = orange
    static let lowStock = red
    static let mediumStock = yellow
    static let normalStock = green
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [
            primaryBackground,
            secondaryBackground,
            Color(red: 0.12, green: 0.18, blue: 0.32)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        gradient: Gradient(colors: [
            secondaryBackground.opacity(0.8),
            tertiaryBackground.opacity(0.6)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        gradient: Gradient(colors: [
            lightBlue,
            lightBlue.opacity(0.8)
        ]),
        startPoint: .leading,
        endPoint: .trailing
    )
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(ColorTheme.cardGradient)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

struct PrimaryButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(ColorTheme.primaryText)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(ColorTheme.buttonGradient)
            .cornerRadius(8)
            .shadow(color: ColorTheme.lightBlue.opacity(0.3), radius: 4, x: 0, y: 2)
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardStyle())
    }
    
    func primaryButtonStyle() -> some View {
        self.modifier(PrimaryButtonStyle())
    }
}
