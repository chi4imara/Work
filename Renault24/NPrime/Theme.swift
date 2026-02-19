import SwiftUI

struct AppColors {
    static let primary = Color(red: 0.08, green: 0.12, blue: 0.25)
    static let secondary = Color(red: 0.12, green: 0.16, blue: 0.30)
    static let accent = Color(red: 1.0, green: 0.58, blue: 0.0)
    static let accentSecondary = Color(red: 0.9, green: 0.5, blue: 0.1)
    
    static let background = LinearGradient(
        colors: [
            Color(red: 0.06, green: 0.10, blue: 0.22),
            Color(red: 0.10, green: 0.14, blue: 0.28),
            Color(red: 0.08, green: 0.12, blue: 0.25)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let cardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.15),
            Color.white.opacity(0.05)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentGradient = LinearGradient(
        colors: [
            accent,
            accentSecondary
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let text = Color.white
    static let textSecondary = Color.white.opacity(0.7)
    static let textTertiary = Color.white.opacity(0.5)
    
    static let cardBackground = Color.white.opacity(0.1)
    static let cardBackgroundSecondary = Color.white.opacity(0.05)
    
    static let success = Color(red: 0.2, green: 0.8, blue: 0.4)
    static let warning = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let error = Color(red: 0.9, green: 0.3, blue: 0.3)
    static let info = Color(red: 0.3, green: 0.7, blue: 1.0)
    
    static let shadowColor = Color.black.opacity(0.3)
    static let shadowColorLight = Color.black.opacity(0.1)
}

struct AppStyles {
    static let cornerRadius: CGFloat = 16
    static let smallCornerRadius: CGFloat = 8
    static let mediumCornerRadius: CGFloat = 12
    static let largeCornerRadius: CGFloat = 24
    
    static let cardPadding: CGFloat = 16
    static let sectionSpacing: CGFloat = 20
    static let smallSpacing: CGFloat = 8
    static let mediumSpacing: CGFloat = 16
    static let largeSpacing: CGFloat = 24
    static let extraLargeSpacing: CGFloat = 32
    
    static let buttonHeight: CGFloat = 50
    static let smallButtonHeight: CGFloat = 40
    static let iconSize: CGFloat = 24
    static let smallIconSize: CGFloat = 16
    static let largeIconSize: CGFloat = 32
    
    static let shadowRadius: CGFloat = 8
    static let shadowOffset = CGSize(width: 0, height: 4)
    static let lightShadowRadius: CGFloat = 4
    static let lightShadowOffset = CGSize(width: 0, height: 2)
}

extension View {
    func cardStyle() -> some View {
        self
            .background(AppColors.cardGradient)
            .cornerRadius(AppStyles.cornerRadius)
            .shadow(
                color: AppColors.shadowColor,
                radius: AppStyles.shadowRadius,
                x: AppStyles.shadowOffset.width,
                y: AppStyles.shadowOffset.height
            )
    }
    
    func lightCardStyle() -> some View {
        self
            .background(AppColors.cardBackground)
            .cornerRadius(AppStyles.smallCornerRadius)
            .shadow(
                color: AppColors.shadowColorLight,
                radius: AppStyles.lightShadowRadius,
                x: AppStyles.lightShadowOffset.width,
                y: AppStyles.lightShadowOffset.height
            )
    }
    
    func primaryButtonStyle() -> some View {
        self
            .frame(height: AppStyles.buttonHeight)
            .background(AppColors.accentGradient)
            .foregroundColor(.white)
            .cornerRadius(AppStyles.cornerRadius)
            .font(.ubuntu(16, weight: .medium))
            .shadow(
                color: AppColors.shadowColor,
                radius: AppStyles.lightShadowRadius,
                x: 0,
                y: 2
            )
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .frame(height: AppStyles.buttonHeight)
            .background(AppColors.cardBackground)
            .foregroundColor(AppColors.text)
            .cornerRadius(AppStyles.cornerRadius)
            .font(.ubuntu(16, weight: .medium))
            .overlay(
                RoundedRectangle(cornerRadius: AppStyles.cornerRadius)
                    .stroke(AppColors.accent, lineWidth: 1)
            )
    }
    
    func smallButtonStyle() -> some View {
        self
            .frame(height: AppStyles.smallButtonHeight)
            .background(AppColors.accent)
            .foregroundColor(.white)
            .cornerRadius(AppStyles.smallCornerRadius)
            .font(.ubuntu(14, weight: .medium))
    }
    
    func titleTextStyle() -> some View {
        self
            .font(.ubuntu(24, weight: .bold))
            .foregroundColor(AppColors.text)
    }
    
    func subtitleTextStyle() -> some View {
        self
            .font(.ubuntu(18, weight: .medium))
            .foregroundColor(AppColors.text)
    }
    
    func bodyTextStyle() -> some View {
        self
            .font(.ubuntu(16, weight: .regular))
            .foregroundColor(AppColors.text)
    }
    
    func captionTextStyle() -> some View {
        self
            .font(.ubuntu(14, weight: .regular))
            .foregroundColor(AppColors.textSecondary)
    }
    
    func smallTextStyle() -> some View {
        self
            .font(.ubuntu(12, weight: .regular))
            .foregroundColor(AppColors.textTertiary)
    }
    
    func appBackgroundStyle() -> some View {
        self
            .background(AppColors.background)
    }
}
