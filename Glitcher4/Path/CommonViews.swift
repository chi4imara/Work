import SwiftUI

struct GradientButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    let isEnabled: Bool
    
    init(title: String, icon: String? = nil, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }
                
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
            }
            .foregroundColor(AppColors.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                LinearGradient(
                    colors: isEnabled ? [AppColors.lightBlue, AppColors.orange] : [AppColors.gray, AppColors.gray],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(25)
            .opacity(isEnabled ? 1.0 : 0.6)
        }
        .disabled(!isEnabled)
    }
}

struct CardBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(AppColors.cardGradient)
    }
}

struct SectionHeader: View {
    let title: String
    let subtitle: String?
    
    init(title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(AppColors.white)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.white.opacity(0.7))
            }
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.white.opacity(0.5))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.white)
                
                Text(message)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 32)
    }
}

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 16) {
            Circle()
                .stroke(AppColors.lightBlue, lineWidth: 3)
                .frame(width: 30, height: 30)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(.linear(duration: 1.0).repeatForever(autoreverses: false), value: isAnimating)
            
            Text("Loading...")
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(AppColors.white.opacity(0.7))
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppColors.cardGradient)
            .cornerRadius(16)
    }
}

struct PrimaryButtonStyle: ViewModifier {
    let isEnabled: Bool
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(AppColors.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                LinearGradient(
                    colors: isEnabled ? [AppColors.lightBlue, AppColors.orange] : [AppColors.gray, AppColors.gray],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(25)
            .opacity(isEnabled ? 1.0 : 0.6)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
    
    func primaryButtonStyle(isEnabled: Bool = true) -> some View {
        modifier(PrimaryButtonStyle(isEnabled: isEnabled))
    }
}
