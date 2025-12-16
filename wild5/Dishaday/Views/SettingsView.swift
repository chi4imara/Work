import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            
            VStack(spacing: 0) {
                HeaderView()
                
                SettingsContentView()
            }
        }
        .alert("Rate Our App", isPresented: $showingRateAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Rate Now") {
                requestAppReview()
            }
        } message: {
            Text("If you enjoy using our app, please take a moment to rate it. Your feedback helps us improve!")
        }
    }
    
    @ViewBuilder
    private func HeaderView() -> some View {
        HStack {
            Text("Settings")
                .font(.playfairTitleLarge(28))
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    @ViewBuilder
    private func SettingsContentView() -> some View {
        ScrollView {
            VStack(spacing: 24) {
                SettingsSection(title: "App") {
                    VStack(spacing: 0) {
                        SettingsRow(
                            icon: "star.fill",
                            iconColor: .primaryYellow,
                            title: "Rate App",
                            subtitle: "Help us improve"
                        ) {
                            showingRateAlert = true
                        }
                        
                        Divider()
                            .background(Color.cardBorder)
                            .padding(.leading, 60)
                        
                        SettingsRow(
                            icon: "envelope.fill",
                            iconColor: .accentGreen,
                            title: "Contact Us",
                            subtitle: "Get in touch"
                        ) {
                            openURL("https://www.privacypolicies.com/live/680accfd-5227-472c-87fb-8fbb9fda3d0b")
                        }
                    }
                }
                
                SettingsSection(title: "Legal") {
                    VStack(spacing: 0) {
                        SettingsRow(
                            icon: "doc.text.fill",
                            iconColor: .accentPurple,
                            title: "Terms of Use",
                            subtitle: "User agreement"
                        ) {
                            openURL("https://www.privacypolicies.com/live/eed2c01d-b310-4ae1-a7b8-eeed9f3bf53d")
                        }
                        
                        Divider()
                            .background(Color.cardBorder)
                            .padding(.leading, 60)
                        
                        SettingsRow(
                            icon: "hand.raised.fill",
                            iconColor: .accentOrange,
                            title: "Privacy Policy",
                            subtitle: "Data protection"
                        ) {
                            openURL("https://www.privacypolicies.com/live/680accfd-5227-472c-87fb-8fbb9fda3d0b")
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.playfairHeading(20))
                .foregroundColor(.textPrimary)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    )
            )
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.playfairBody(16))
                        .foregroundColor(.textPrimary)
                    
                    Text(subtitle)
                        .font(.playfairCaption(14))
                        .foregroundColor(.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textTertiary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}


#Preview {
    SettingsView()
}
