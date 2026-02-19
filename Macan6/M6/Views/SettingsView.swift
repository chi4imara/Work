import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView(showsIndicators: false) {
                    settingsContent
                }
            }
        }
        .alert(isPresented: $showingRateAlert) {
            rateAppAlert
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
    
    private var settingsContent: some View {
        VStack(spacing: 24) {
            SettingsSection(title: "App") {
                VStack(spacing: 0) {
                    SettingsRow(
                        icon: "star.fill",
                        title: "Rate App",
                        subtitle: "Help us improve by rating the app"
                    ) {
                        requestAppReview()
                    }
                    
                    Divider()
                        .background(AppColors.gridColor)
                        .padding(.horizontal, 16)
                    
                    SettingsRow(
                        icon: "envelope.fill",
                        title: "Contact Us",
                        subtitle: "Get in touch with our team"
                    ) {
                        openURL("https://www.privacypolicies.com/live/1165a5a7-dbe5-4f6c-a622-28756241677f")
                    }
                }
            }
            
            SettingsSection(title: "Legal") {
                VStack(spacing: 0) {
                    SettingsRow(
                        icon: "doc.text.fill",
                        title: "Terms of Use",
                        subtitle: "Read our terms and conditions"
                    ) {
                        openURL("https://www.privacypolicies.com/live/56f11596-9c9d-4944-a3ad-7ea812b5f8be")
                    }
                    
                    Divider()
                        .background(AppColors.gridColor)
                        .padding(.horizontal, 16)
                    
                    SettingsRow(
                        icon: "lock.shield.fill",
                        title: "Privacy Policy",
                        subtitle: "Learn about data protection"
                    ) {
                        openURL("https://www.privacypolicies.com/live/1165a5a7-dbe5-4f6c-a622-28756241677f")
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 120)
    }
    
    private var rateAppAlert: Alert {
        Alert(
            title: Text("Rate Our App"),
            message: Text("If you enjoy using Beauty Test Diary, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!"),
            primaryButton: .default(Text("Rate Now")) {
                requestAppStoreReview()
            },
            secondaryButton: .cancel(Text("Maybe Later"))
        )
    }
    
    private func requestAppReview() {
        showingRateAlert = true
    }
    
    private func requestAppStoreReview() {
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
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 0) {
                content
            }
            .cardStyle()
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.yellow)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(subtitle)
                        .font(.playfairDisplay(14))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(16)
        }
    }
}

#Preview {
    SettingsView()
}
