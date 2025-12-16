import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    var body: some View {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        VStack(spacing: 12) {
                            Text("Settings")
                                .font(.ubuntu(32, weight: .bold))
                                .foregroundColor(Color.theme.primaryWhite)
                            
                            Text("App Information & Support")
                                .font(.ubuntu(16, weight: .regular))
                                .foregroundColor(Color.theme.primaryWhite.opacity(0.8))
                        }
                        .padding(.top, 30)
                        .padding(.bottom, 40)
                        
                        VStack(spacing: 24) {
                            SettingsRow {
                                SettingsButton(
                                    title: "Terms & Conditions",
                                    subtitle: "Read our terms of use",
                                    icon: "doc.text.fill",
                                    gradient: LinearGradient(
                                        gradient: Gradient(colors: [Color.theme.primaryPurple, Color.theme.primaryPurple.opacity(0.8)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    action: {
                                        openURL("https://doc-hosting.flycricket.io/kitly-cosmybox/cdf9f4c4-aaff-46d9-889e-34645c5625a1/terms")
                                    }
                                )
                            }
                            
                            SettingsRow {
                                SettingsButton(
                                    title: "Privacy Policy",
                                    subtitle: "How we protect your data",
                                    icon: "lock.shield.fill",
                                    gradient: LinearGradient(
                                        gradient: Gradient(colors: [Color.theme.accentGreen, Color.theme.accentGreen.opacity(0.7)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    action: {
                                        openURL("https://doc-hosting.flycricket.io/kitly-cosmybox-privacy-policy/8bf7e440-47f8-4ea1-81a9-d36f5e498789/privacy")
                                    }
                                )
                            }
                            
                            SettingsRow {
                                SettingsButton(
                                    title: "Contact Us",
                                    subtitle: "Get in touch with us",
                                    icon: "envelope.fill",
                                    gradient: LinearGradient(
                                        gradient: Gradient(colors: [Color.theme.accentOrange, Color.theme.accentOrange.opacity(0.7)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    action: {
                                        openURL("https://forms.gle/QDY3gezsdZJGuuaP7")
                                    }
                                )
                            }
                            
                            SettingsRow {
                                SettingsButton(
                                    title: "Rate App",
                                    subtitle: "Share your feedback",
                                    icon: "star.fill",
                                    gradient: LinearGradient(
                                        gradient: Gradient(colors: [Color.theme.primaryYellow, Color.theme.primaryYellow.opacity(0.8)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    textColor: Color.theme.darkGray,
                                    action: {
                                        requestReview()
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 50)
                    }
                    .padding(.bottom, 100)
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

struct SettingsRow<Content: View>: View {
    @ViewBuilder let content: Content
    
    var body: some View {
        HStack {
            content
        }
    }
}

struct SettingsButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let gradient: LinearGradient
    var textColor: Color = Color.theme.primaryWhite
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(textColor.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(textColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(textColor)
                    
                    Text(subtitle)
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(textColor.opacity(0.85))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(textColor.opacity(0.7))
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(gradient)
                    .shadow(color: Color.black.opacity(0.15), radius: isPressed ? 8 : 12, x: 0, y: isPressed ? 4 : 6)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(textColor.opacity(0.1), lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
        }
    }
}

#Preview {
    SettingsView()
}
