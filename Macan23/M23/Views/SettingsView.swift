import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            AnimatedBubblesBackground()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        SettingsSectionView(title: "App") {
                            VStack(spacing: 0) {
                                SettingsRowView(
                                    title: "Rate App",
                                    icon: "star.fill",
                                    action: { showRateAppAlert() }
                                )
                            }
                        }
                        
                        SettingsSectionView(title: "Legal") {
                            VStack(spacing: 0) {
                                SettingsRowView(
                                    title: "Terms of Use",
                                    icon: "doc.text.fill",
                                    action: { openURL("https://www.privacypolicies.com/live/65c4ce11-84f8-44c0-8ac8-81818697e788") }
                                )
                                
                                Divider()
                                    .background(AppColors.secondaryText.opacity(0.3))
                                    .padding(.leading, 50)
                                
                                SettingsRowView(
                                    title: "Privacy Policy",
                                    icon: "hand.raised.fill",
                                    action: { openURL("https://www.privacypolicies.com/live/4390f97f-3350-4068-89c0-42238c64c998") }
                                )
                            }
                        }
                        
                        SettingsSectionView(title: "Support") {
                            SettingsRowView(
                                title: "Contact Us",
                                icon: "envelope.fill",
                                action: { openURL("https://www.privacypolicies.com/live/4390f97f-3350-4068-89c0-42238c64c998") }
                            )
                        }
                    }
                    .padding(.vertical, 20)
                }
            }
        }
        .alert("Rate Our App", isPresented: $showingRateAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Rate") {
                requestAppStoreReview()
            }
        } message: {
            Text("If you enjoy using our app, please take a moment to rate it. Your feedback helps us improve!")
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            Text("Settings")
                .font(.ubuntu(size: 32, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 16)
    }
    
    private func showRateAppAlert() {
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

struct SettingsSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.ubuntu(size: 18, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                content
            }
            .cardStyle()
            .padding(.horizontal, 20)
        }
    }
}

struct SettingsRowView: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.accent.opacity(0.2))
                        .frame(width: 34, height: 34)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.accent)
                }
                
                Text(title)
                    .font(.ubuntu(size: 16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
    }
}
