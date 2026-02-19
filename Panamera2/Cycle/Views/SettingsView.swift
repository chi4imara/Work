import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.bauhausBold(size: 28))
                        .foregroundColor(AppColors.primaryWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            SettingsButton(
                                title: "Privacy Policy",
                                icon: "lock.shield",
                                action: { openURL("https://www.termsfeed.com/live/35f005d0-8881-4597-ae01-ea34f5cfc35c") }
                            )
                            
                            HStack(spacing: 16) {
                                SettingsButton(
                                    title: "Contact Us",
                                    icon: "envelope",
                                    isCompact: true,
                                    action: { openURL("https://www.termsfeed.com/live/35f005d0-8881-4597-ae01-ea34f5cfc35c") }
                                )
                                
                                SettingsButton(
                                    title: "Rate App",
                                    icon: "star",
                                    isCompact: true,
                                    action: { requestReview() }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 120)
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

struct SettingsButton: View {
    let title: String
    let icon: String
    var isCompact: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: isCompact ? 24 : 30, weight: .medium))
                    .foregroundColor(AppColors.accentYellow)
                
                Text(title)
                    .font(.bauhausBold(size: isCompact ? 14 : 16))
                    .foregroundColor(AppColors.primaryWhite)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: isCompact ? 100 : 120)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [AppColors.accentYellow.opacity(0.3), AppColors.primaryPink.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(AppColors.accentYellow.opacity(0.5), lineWidth: 2)
            )
        }
    }
}

struct SettingsButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    SettingsView()
}
