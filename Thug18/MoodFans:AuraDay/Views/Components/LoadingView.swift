import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: AppTheme.Spacing.lg) {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 4)
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(
                            AppTheme.Colors.accentYellow,
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                        .animation(.linear(duration: 1.0).repeatForever(autoreverses: false), value: isAnimating)
                }
                
                Text("Loading...")
                    .font(AppTheme.Fonts.callout)
                    .foregroundColor(AppTheme.Colors.primaryText)
            }
            .padding(AppTheme.Spacing.xl)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                    .fill(AppTheme.Colors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let description: String
    let buttonTitle: String?
    let buttonAction: (() -> Void)?
    
    init(
        icon: String,
        title: String,
        description: String,
        buttonTitle: String? = nil,
        buttonAction: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppTheme.Colors.accentYellow)
            
            VStack(spacing: AppTheme.Spacing.md) {
                Text(title)
                    .font(AppTheme.Fonts.title3)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(AppTheme.Fonts.body)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            
            if let buttonTitle = buttonTitle, let buttonAction = buttonAction {
                Button(action: buttonAction) {
                    Text(buttonTitle)
                        .font(AppTheme.Fonts.buttonFont)
                        .foregroundColor(AppTheme.Colors.backgroundBlue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppTheme.Colors.accentYellow)
                        .cornerRadius(AppTheme.CornerRadius.large)
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
            }
            
            Spacer()
        }
    }
}

#Preview {
    ZStack {
        AppTheme.Colors.backgroundGradient
            .ignoresSafeArea()
        
        EmptyStateView(
            icon: "star",
            title: "No favorites yet",
            description: "Add some favorite days to see them here",
            buttonTitle: "Add Favorite",
            buttonAction: {}
        )
    }
}
