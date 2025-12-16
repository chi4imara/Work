import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(spacing: 25) {
                        SettingsCard(
                            icon: "doc.text.fill",
                            title: "Terms of Use",
                            subtitle: "Legal information",
                            color: AppColors.primary,
                            position: .leading,
                            rotation: -3
                        ) {
                            openURL("https://www.privacypolicies.com/live/b96eb5c4-7509-494c-88de-229f76338527")
                        }
                        
                        SettingsCard(
                            icon: "shield.fill",
                            title: "Privacy Policy",
                            subtitle: "Data protection",
                            color: AppColors.accent,
                            position: .trailing,
                            rotation: 2
                        ) {
                            openURL("https://www.privacypolicies.com/live/0346b9df-21e2-490a-85a5-1701a6c508dc")
                        }
                        
                        SettingsCard(
                            icon: "envelope.fill",
                            title: "Contact Us",
                            subtitle: "Get in touch",
                            color: AppColors.secondary,
                            position: .center,
                            rotation: -1,
                            isLarge: true
                        ) {
                            openURL("https://www.privacypolicies.com/live/0346b9df-21e2-490a-85a5-1701a6c508dc")
                        }
                        
                        SettingsCard(
                            icon: "star.fill",
                            title: "Rate App",
                            subtitle: "Share your feedback",
                            color: AppColors.warning,
                            position: .leading,
                            rotation: 1
                        ) {
                            requestReview()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

enum CardPosition {
    case leading
    case center
    case trailing
}

struct SettingsCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let position: CardPosition
    let rotation: Double
    var isLarge: Bool = false
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var hoverOffset: CGFloat = 0
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [color.opacity(0.3), color.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text(subtitle)
                        .font(.ubuntu(14))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.trailing, 8)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.cardGradient)
                    .shadow(
                        color: isPressed ? color.opacity(0.2) : color.opacity(0.15),
                        radius: isPressed ? 8 : 12,
                        x: 0,
                        y: isPressed ? 3 : 6
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [color.opacity(0.3), color.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
        }
    }
}

#Preview {
    SettingsView()
}
