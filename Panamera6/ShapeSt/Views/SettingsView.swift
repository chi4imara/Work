import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        Text("Settings")
                            .font(.lumierepolis(size: 32, weight: .bold))
                            .foregroundColor(ColorTheme.white)
                        
                        Text("Manage your preferences")
                            .font(.lumierepolis(size: 16))
                            .foregroundColor(ColorTheme.white.opacity(0.7))
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
                    VStack(spacing: 16) {
                        SettingsCard(
                            icon: "envelope.fill",
                            title: "Contact Email",
                            subtitle: "Get in touch with us",
                            iconColor: ColorTheme.accent,
                            iconBackground: ColorTheme.accent.opacity(0.2)
                        ) {
                            openURL("https://forms.gle/GiTArjB1cXqysdHz6")
                        }
                        
                        SettingsCard(
                            icon: "hand.raised.fill",
                            title: "Privacy Policy",
                            subtitle: "How we protect your data",
                            iconColor: ColorTheme.lightBlue,
                            iconBackground: ColorTheme.lightBlue.opacity(0.2)
                        ) {
                            openURL("https://www.freeprivacypolicy.com/live/381aae92-ce3f-42fc-ac5e-161dfd8e940b")
                        }
                        
                        SettingsCard(
                            icon: "star.fill",
                            title: "Rate App",
                            subtitle: "Love it? Share your feedback",
                            iconColor: ColorTheme.orange,
                            iconBackground: ColorTheme.orange.opacity(0.2)
                        ) {
                            showingRateAlert = true
                        }
                    }
                    .padding(.horizontal, 20)
                    
                }
                .padding(.bottom, 120)
            }
        }
        .alert("Rate Our App", isPresented: $showingRateAlert) {
            Button("Rate Now") {
                requestAppReview()
            }
            Button("Maybe Later", role: .cancel) { }
        } message: {
            Text("If you enjoy using our app, please take a moment to rate it. It really helps us!")
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconColor: Color
    let iconBackground: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconBackground)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.lumierepolis(size: 18, weight: .bold))
                        .foregroundColor(ColorTheme.white)
                    
                    Text(subtitle)
                        .font(.lumierepolis(size: 14))
                        .foregroundColor(ColorTheme.white.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ColorTheme.white.opacity(0.5))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(ColorTheme.white.opacity(0.1), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
    }
}
