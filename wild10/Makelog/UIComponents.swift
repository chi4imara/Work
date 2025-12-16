import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(AppColors.primaryPurple, lineWidth: 4)
                .frame(width: 50, height: 50)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    .linear(duration: 1.0)
                    .repeatForever(autoreverses: false),
                    value: isAnimating
                )
            
            Text("Loading...")
                .font(AppFonts.callout)
                .foregroundColor(AppColors.textSecondary)
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
        VStack(spacing: AppSpacing.lg) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.textSecondary)
            
            VStack(spacing: AppSpacing.sm) {
                Text(title)
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if let buttonTitle = buttonTitle, let buttonAction = buttonAction {
                Button(action: {
                    HapticFeedback.light()
                    buttonAction()
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .semibold))
                        Text(buttonTitle)
                            .font(AppFonts.headline)
                    }
                    .foregroundColor(AppColors.buttonText)
                    .buttonStyle(background: AppColors.buttonBackground)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.xl)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    let isEnabled: Bool
    
    init(isEnabled: Bool = true) {
        self.isEnabled = isEnabled
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(isEnabled ? AppColors.buttonText : AppColors.textTertiary)
            .buttonStyle(background: isEnabled ? AppColors.buttonBackground : AppColors.cardBackground)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(AppColors.textPrimary)
            .padding(.horizontal, AppSpacing.lg)
            .padding(.vertical, AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                            .fill(AppColors.cardBackground)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct CategoryBadge: View {
    let category: WeatherCategory
    let size: BadgeSize
    
    enum BadgeSize {
        case small, medium, large
        
        var font: Font {
            switch self {
            case .small: return AppFonts.caption2
            case .medium: return AppFonts.caption1
            case .large: return AppFonts.callout
            }
        }
        
        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6)
            case .medium: return EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
            case .large: return EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
            }
        }
    }
    
    init(category: WeatherCategory, size: BadgeSize = .medium) {
        self.category = category
        self.size = size
    }
    
    var body: some View {
        Text(category.name)
            .font(size.font)
            .foregroundColor(AppColors.buttonText)
            .padding(size.padding)
            .background(
                RoundedRectangle(cornerRadius: AppCornerRadius.small)
                    .fill(AppColors.primaryPurple)
            )
    }
}

struct FloatingActionButton: View {
    let icon: String
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            HapticFeedback.medium()
            action()
        }) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(AppColors.buttonText)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(AppColors.buttonBackground)
                        .shadow(color: AppShadows.medium, radius: 8, x: 0, y: 4)
                )
        }
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    VStack(spacing: AppSpacing.lg) {
        LoadingView()
        
        CategoryBadge(category: WeatherCategory.sunny, size: .medium)
        
        FloatingActionButton(icon: "plus") {
            print("FAB tapped")
        }
    }
    .padding()
    .background(AppColors.backgroundGradientStart)
}
