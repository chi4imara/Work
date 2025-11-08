import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let accentYellow = Color(red: 1.0, green: 0.85, blue: 0.0)
    static let pureWhite = Color.white
    static let softWhite = Color(red: 0.98, green: 0.98, blue: 1.0)
    
    static let lightPurple = Color(red: 0.7, green: 0.6, blue: 1.0)
    static let softPink = Color(red: 1.0, green: 0.7, blue: 0.8)
    static let mintGreen = Color(red: 0.6, green: 1.0, blue: 0.8)
    static let peachOrange = Color(red: 1.0, green: 0.8, blue: 0.6)
    
    static let lightGray = Color(red: 0.9, green: 0.9, blue: 0.95)
    static let mediumGray = Color(red: 0.7, green: 0.7, blue: 0.75)
    static let darkGray = Color(red: 0.3, green: 0.3, blue: 0.35)
    
    static let primaryGradient = LinearGradient(
        colors: [primaryBlue, lightPurple, softPink],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let secondaryGradient = LinearGradient(
        colors: [primaryBlue.opacity(0.8), mintGreen.opacity(0.6)],
        startPoint: .top,
        endPoint: .bottom
    )
    
    static let cardGradient = LinearGradient(
        colors: [pureWhite.opacity(0.9), softWhite.opacity(0.7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        colors: [accentYellow, peachOrange],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let glowEffect = RadialGradient(
        colors: [pureWhite.opacity(0.3), Color.clear],
        center: .center,
        startRadius: 10,
        endRadius: 100
    )
    
    static let ringEffect = RadialGradient(
        colors: [pureWhite.opacity(0.2), pureWhite.opacity(0.1), Color.clear],
        center: .center,
        startRadius: 50,
        endRadius: 150
    )
}

struct AnimatedBackgroundView: View {
    @State private var animateRings = false
    @State private var animateGlow = false
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .stroke(AppColors.pureWhite.opacity(0.1), lineWidth: 2)
                    .frame(width: 200 + CGFloat(index * 100), height: 200 + CGFloat(index * 100))
                    .offset(x: animateRings ? 50 : -50, y: animateRings ? -30 : 30)
                    .animation(
                        Animation.easeInOut(duration: 3 + Double(index))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.5),
                        value: animateRings
                    )
            }
            
            ForEach(0..<5, id: \.self) { index in
                Circle()
                    .fill(AppColors.glowEffect)
                    .frame(width: 80, height: 80)
                    .offset(
                        x: animateGlow ? CGFloat.random(in: -100...100) : CGFloat.random(in: -50...50),
                        y: animateGlow ? CGFloat.random(in: -150...150) : CGFloat.random(in: -75...75)
                    )
                    .animation(
                        Animation.easeInOut(duration: 4 + Double(index))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.8),
                        value: animateGlow
                    )
            }
        }
        .onAppear {
            animateRings = true
            animateGlow = true
        }
    }
}

struct CardBackgroundStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: AppColors.primaryBlue.opacity(0.2), radius: 8, x: 0, y: 4)
            )
    }
}

extension View {
    func cardBackground() -> some View {
        modifier(CardBackgroundStyle())
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(FontManager.buttonText)
            .foregroundColor(AppColors.darkGray)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(AppColors.buttonGradient)
                    .shadow(color: AppColors.accentYellow.opacity(0.3), radius: 4, x: 0, y: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(FontManager.buttonText)
            .foregroundColor(AppColors.pureWhite)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(AppColors.pureWhite.opacity(0.6), lineWidth: 1.5)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppColors.pureWhite.opacity(0.1))
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
