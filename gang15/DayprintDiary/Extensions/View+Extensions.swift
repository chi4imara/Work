import SwiftUI

extension View {
    func appBackground() -> some View {
        self.background(
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
            }
        )
    }
    
    func cardBackground() -> some View {
        self
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.lg)
    }
    
    func primaryButtonStyle() -> some View {
        self
            .font(AppTheme.Typography.headline)
            .foregroundColor(AppTheme.Colors.primaryText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(AppTheme.Colors.primaryPurple)
            .cornerRadius(AppTheme.CornerRadius.md)
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .font(AppTheme.Typography.callout)
            .foregroundColor(AppTheme.Colors.primaryText)
            .padding(.vertical, AppTheme.Spacing.sm)
            .padding(.horizontal, AppTheme.Spacing.md)
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.sm)
    }
}
