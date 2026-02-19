import SwiftUI

struct AppTheme {
    
    struct Colors {
        static let primaryBackground = Color(red: 0.1, green: 0.15, blue: 0.3)
        static let secondaryBackground = Color(red: 0.15, green: 0.2, blue: 0.35)
        static let cardBackground = Color(red: 0.2, green: 0.25, blue: 0.4)
        
        static let primaryText = Color.white
        static let secondaryText = Color(red: 0.8, green: 0.85, blue: 0.9)
        static let placeholderText = Color(red: 0.6, green: 0.65, blue: 0.7)
        
        static let accent = Color(red: 0.4, green: 0.7, blue: 1.0) 
        static let accentSecondary = Color(red: 0.5, green: 0.8, blue: 1.0)
        
        static let success = Color(red: 0.2, green: 0.8, blue: 0.4)
        static let warning = Color(red: 1.0, green: 0.6, blue: 0.2)
        static let error = Color(red: 1.0, green: 0.3, blue: 0.3)
        
        static let buttonPrimary = accent
        static let buttonSecondary = Color(red: 0.3, green: 0.4, blue: 0.6)
        static let buttonDisabled = Color(red: 0.4, green: 0.4, blue: 0.4)
        
        static let border = Color(red: 0.3, green: 0.4, blue: 0.5)
        static let borderActive = accent
    }
    
    struct Gradients {
        static let primaryBackground = LinearGradient(
            gradient: Gradient(colors: [
                Colors.primaryBackground,
                Colors.secondaryBackground
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let cardBackground = LinearGradient(
            gradient: Gradient(colors: [
                Colors.cardBackground,
                Colors.cardBackground.opacity(0.8)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let accentGradient = LinearGradient(
            gradient: Gradient(colors: [
                Colors.accent,
                Colors.accentSecondary
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
        
        static let splashGradient = RadialGradient(
            gradient: Gradient(colors: [
                Colors.accent.opacity(0.3),
                Colors.primaryBackground
            ]),
            center: .center,
            startRadius: 50,
            endRadius: 300
        )
    }
    
    struct Typography {
        static let largeTitle: CGFloat = 34
        static let title1: CGFloat = 28
        static let title2: CGFloat = 22
        static let title3: CGFloat = 20
        static let headline: CGFloat = 17
        static let body: CGFloat = 17
        static let callout: CGFloat = 16
        static let subheadline: CGFloat = 15
        static let footnote: CGFloat = 13
        static let caption1: CGFloat = 12
        static let caption2: CGFloat = 11
        
        static let light = Font.Weight.light
        static let regular = Font.Weight.regular
        static let medium = Font.Weight.medium
        static let semibold = Font.Weight.semibold
        static let bold = Font.Weight.bold
    }
    
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
    }
    
    struct Shadows {
        static let card = Color.black.opacity(0.1)
        static let button = Color.black.opacity(0.2)
    }
}

extension View {
    func primaryBackground() -> some View {
        self.background(AppTheme.Gradients.primaryBackground.ignoresSafeArea())
    }
    
    func cardBackground() -> some View {
        self
            .frame(maxWidth: .infinity)
            .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(AppTheme.Gradients.cardBackground)
                .shadow(color: AppTheme.Shadows.card, radius: 4, x: 0, y: 2)
        )
    }
    
    func primaryButton() -> some View {
        self
            .font(.playfairDisplay(AppTheme.Typography.body, weight: .semiBold))
            .foregroundColor(AppTheme.Colors.primaryText)
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.md)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(AppTheme.Gradients.accentGradient)
                    .shadow(color: AppTheme.Shadows.button, radius: 4, x: 0, y: 2)
            )
    }
    
    func secondaryButton() -> some View {
        self
            .font(.playfairDisplay(AppTheme.Typography.body, weight: .semiBold))
            .foregroundColor(AppTheme.Colors.secondaryText)
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.md)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(AppTheme.Colors.buttonSecondary)
                    .shadow(color: AppTheme.Shadows.button, radius: 2, x: 0, y: 1)
            )
    }
}
