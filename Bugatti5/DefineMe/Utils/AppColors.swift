import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.2, green: 0.6, blue: 1.0)
    static let lightBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let darkBlue = Color(red: 0.1, green: 0.4, blue: 0.8)
    
    static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let brightYellow = Color(red: 1.0, green: 0.9, blue: 0.2)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let placeholderText = Color.white.opacity(0.6)
    
    static let primaryBackground = LinearGradient(
        colors: [primaryBlue, lightBlue, darkBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color.white.opacity(0.1)
    static let overlayBackground = Color.black.opacity(0.3)
    
    static let buttonBackground = accentYellow
    static let buttonText = Color.black
    static let secondaryButtonBackground = Color.white.opacity(0.2)
    
    static let gridPattern = Color.white.opacity(0.1)
}

struct AppStyles {
    static let primaryButton = PrimaryButtonStyle()
    static let secondaryButton = SecondaryButtonStyle()
    static let destructiveButton = DestructiveButtonStyle()
    
    static let primaryTextField = PrimaryTextFieldStyle()
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
}

extension ButtonStyle where Self == SecondaryButtonStyle {
    static var secondary: SecondaryButtonStyle { SecondaryButtonStyle() }
}

extension ButtonStyle where Self == DestructiveButtonStyle {
    static var destructive: DestructiveButtonStyle { DestructiveButtonStyle() }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.ubuntu(16, weight: .medium))
            .foregroundColor(AppColors.buttonText)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.buttonBackground)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.ubuntu(16, weight: .medium))
            .foregroundColor(AppColors.primaryText)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.secondaryButtonBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.primaryText.opacity(0.3), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct DestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.ubuntu(16, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.red)
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension TextFieldStyle where Self == PrimaryTextFieldStyle {
    static var primary: PrimaryTextFieldStyle { PrimaryTextFieldStyle() }
}

struct PrimaryTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.ubuntu(16))
            .foregroundColor(AppColors.primaryText)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.primaryText.opacity(0.3), lineWidth: 1)
                    )
            )
    }
}
