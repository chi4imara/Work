import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.1, green: 0.2, blue: 0.4)
    static let darkBlue = Color(red: 0.05, green: 0.1, blue: 0.25)
    static let lightBlue = Color(red: 0.3, green: 0.6, blue: 0.9)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let accentText = Color(red: 0.4, green: 0.8, blue: 1.0)
    
    static let backgroundGradient = LinearGradient(
        colors: [darkBlue, primaryBlue, Color(red: 0.15, green: 0.25, blue: 0.45)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.1)
    static let cardBorder = Color.white.opacity(0.2)
    
    static let primaryButton = lightBlue
    static let secondaryButton = orange
    static let dangerButton = Color.red.opacity(0.8)
    
    static let tabBarBackground = Color.black.opacity(0.3)
    static let tabBarSelected = lightBlue
    static let tabBarUnselected = Color.white.opacity(0.6)
}

struct BackgroundView: View {
    var body: some View {
        AppColors.backgroundGradient
            .ignoresSafeArea()
    }
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.ubuntu(16, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(AppColors.primaryButton)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.ubuntu(16, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(AppColors.secondaryButton)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct DangerButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.ubuntu(16, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(AppColors.dangerButton)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
