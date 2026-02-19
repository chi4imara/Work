import SwiftUI

struct AppColors {
    static let primaryPurple = Color(red: 0.9, green: 0.4, blue: 0.6)
    static let deepPurple = Color(red: 0.8, green: 0.3, blue: 0.5)
    static let lightPurple = Color(red: 0.95, green: 0.5, blue: 0.7)
    
    static let accentYellow = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let brightYellow = Color(red: 1.0, green: 0.9, blue: 0.2)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let accentText = accentYellow
    
    static let cardBackground = Color.white.opacity(0.1)
    static let cardBorder = Color.white.opacity(0.2)
    static let errorRed = Color(red: 1.0, green: 0.3, blue: 0.3)
    static let successGreen = Color(red: 0.3, green: 0.8, blue: 0.3)
    
    static let primaryGradient = LinearGradient(
        colors: [primaryPurple, deepPurple, Color(red: 0.7, green: 0.2, blue: 0.4)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [cardBackground, cardBackground.opacity(0.5)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentGradient = LinearGradient(
        colors: [accentYellow, brightYellow],
        startPoint: .leading,
        endPoint: .trailing
    )
}

struct GlassCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppColors.cardGradient)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct PrimaryButtonModifier: ViewModifier {
    let isEnabled: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.playfairDisplay(size: 16, weight: .semibold))
            .foregroundColor(isEnabled ? AppColors.deepPurple : AppColors.secondaryText)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                isEnabled ? AppColors.accentGradient : 
                LinearGradient(colors: [Color.gray.opacity(0.3)], startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .disabled(!isEnabled)
    }
}

struct SecondaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.playfairDisplay(size: 16, weight: .medium))
            .foregroundColor(AppColors.primaryText)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(AppColors.cardGradient)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.playfairDisplay(size: 16))
            .foregroundColor(AppColors.primaryText)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.cardGradient)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

extension View {
    func glassCard() -> some View {
        modifier(GlassCardModifier())
    }
    
    func primaryButton(isEnabled: Bool = true) -> some View {
        modifier(PrimaryButtonModifier(isEnabled: isEnabled))
    }
    
    func secondaryButton() -> some View {
        modifier(SecondaryButtonModifier())
    }
    
    func customTextField() -> some View {
        modifier(TextFieldModifier())
    }
    
    func primaryBackground() -> some View {
        background(AppColors.primaryGradient.ignoresSafeArea())
    }
}

struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: rect.height * 0.8))
        
        path.addCurve(
            to: CGPoint(x: rect.width * 0.3, y: rect.height * 0.6),
            control1: CGPoint(x: rect.width * 0.1, y: rect.height * 0.7),
            control2: CGPoint(x: rect.width * 0.2, y: rect.height * 0.5)
        )
        
        path.addCurve(
            to: CGPoint(x: rect.width * 0.7, y: rect.height * 0.8),
            control1: CGPoint(x: rect.width * 0.4, y: rect.height * 0.7),
            control2: CGPoint(x: rect.width * 0.6, y: rect.height * 0.9)
        )
        
        path.addCurve(
            to: CGPoint(x: rect.width, y: rect.height * 0.6),
            control1: CGPoint(x: rect.width * 0.8, y: rect.height * 0.7),
            control2: CGPoint(x: rect.width * 0.9, y: rect.height * 0.5)
        )
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}
