import SwiftUI

struct AppColors {
    static let primaryBlue = Color(red: 0.1, green: 0.2, blue: 0.4)
    static let darkBlue = Color(red: 0.05, green: 0.1, blue: 0.2)
    static let lightBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
    static let orange = Color(red: 1.0, green: 0.6, blue: 0.2)
    
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.05, green: 0.1, blue: 0.25),
            Color(red: 0.1, green: 0.15, blue: 0.35),
            Color(red: 0.15, green: 0.2, blue: 0.4)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardBackground = Color(red: 0.15, green: 0.25, blue: 0.45).opacity(0.8)
    static let cardBackgroundSecondary = Color(red: 0.2, green: 0.3, blue: 0.5).opacity(0.6)
    
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.8)
    static let accentText = Color(red: 0.4, green: 0.7, blue: 1.0)
    
    static let success = Color.green
    static let warning = Color.yellow
    static let error = Color.red
    
    static let homeCategory = Color(red: 0.2, green: 0.8, blue: 0.6)
    static let workCategory = Color(red: 0.8, green: 0.4, blue: 0.2)
    static let personalCategory = Color(red: 0.8, green: 0.2, blue: 0.8)
    static let shoppingCategory = Color(red: 0.2, green: 0.6, blue: 0.8)
    static let hobbyCategory = Color(red: 0.8, green: 0.8, blue: 0.2)
    static let otherCategory = Color.gray
}

struct AppTypography {
    static let largeTitle = Font.playfairDisplay(32, weight: .bold)
    static let title = Font.playfairDisplay(24, weight: .semibold)
    static let headline = Font.playfairDisplay(20, weight: .medium)
    static let body = Font.playfairDisplay(16, weight: .regular)
    static let caption = Font.playfairDisplay(14, weight: .regular)
    static let small = Font.playfairDisplay(12, weight: .regular)
}

struct AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

struct AppRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let extraLarge: CGFloat = 24
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppColors.cardBackground)
            .cornerRadius(AppRadius.medium)
            .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

struct PrimaryButtonModifier: ViewModifier {
    let isEnabled: Bool
    
    init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }
    
    func body(content: Content) -> some View {
        content
            .font(AppTypography.headline)
            .foregroundColor(AppColors.primaryText)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: isEnabled ? [AppColors.lightBlue, AppColors.orange] : [Color.gray, Color.gray.opacity(0.7)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(AppRadius.medium)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

struct SecondaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(AppTypography.headline)
            .foregroundColor(AppColors.accentText)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
            .frame(maxWidth: .infinity)
            .background(AppColors.cardBackgroundSecondary)
            .cornerRadius(AppRadius.small)
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.small)
                    .stroke(AppColors.lightBlue, lineWidth: 1)
            )
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardModifier())
    }
    
    func primaryButtonStyle(isEnabled: Bool = true) -> some View {
        self.modifier(PrimaryButtonModifier(isEnabled: isEnabled))
    }
    
    func secondaryButtonStyle() -> some View {
        self.modifier(SecondaryButtonModifier())
    }
}
