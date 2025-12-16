import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                settingsContentView
            }
        }
        .alert("Rate Breathora", isPresented: $showingRateAlert) {
            Button("Rate Now") {
                requestAppStoreReview()
            }
            Button("Maybe Later", role: .cancel) { }
        } message: {
            Text("Enjoying Breathora? Please take a moment to rate us on the App Store!")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.playfairDisplay(size: 28, weight: .bold))
                .foregroundColor(AppColors.darkText)
            
            Spacer()
            
            Image(systemName: "gearshape.fill")
                .font(.system(size: 24))
                .foregroundColor(AppColors.primaryPurple)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var settingsContentView: some View {
        ScrollView {
            VStack(spacing: 24) {
                appInfoSection
                
                legalSection
                
                appVersionSection
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var appInfoSection: some View {
        SettingsSectionView(title: "About") {
            VStack(spacing: 0) {
                SettingsRowView(
                    icon: "star.fill",
                    title: "Rate the App",
                    subtitle: "Help us improve with your feedback",
                    iconColor: AppColors.yellowAccent
                ) {
                    showingRateAlert = true
                }
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsRowView(
                    icon: "envelope.fill",
                    title: "Contact Us",
                    subtitle: "Get in touch with our team",
                    iconColor: AppColors.blueText
                ) {
                    openURL("https://www.privacypolicies.com/live/d3cab773-1a8a-42fc-8d6f-7ec1b25c31b5")
                }
            }
        }
    }
    
    private var legalSection: some View {
        SettingsSectionView(title: "Legal") {
            VStack(spacing: 0) {
                SettingsRowView(
                    icon: "doc.text.fill",
                    title: "Terms of Use",
                    subtitle: "Read our terms and conditions",
                    iconColor: AppColors.primaryPurple
                ) {
                    openURL("https://www.privacypolicies.com/live/a7fe77ec-e5bb-412f-b53e-8773696b810a")
                }
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsRowView(
                    icon: "hand.raised.fill",
                    title: "Privacy Policy",
                    subtitle: "Learn about data protection",
                    iconColor: AppColors.mediumText
                ) {
                    openURL("https://www.privacypolicies.com/live/d3cab773-1a8a-42fc-8d6f-7ec1b25c31b5")
                }
            }
        }
    }
    
    private var supportSection: some View {
        SettingsSectionView(title: "Support") {
            VStack(spacing: 0) {
                SettingsRowView(
                    icon: "questionmark.circle.fill",
                    title: "Help Center",
                    subtitle: "Find answers to common questions",
                    iconColor: AppColors.blueText
                ) {
                    openURL("https://google.com")
                }
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsRowView(
                    icon: "bubble.left.and.bubble.right.fill",
                    title: "Feedback",
                    subtitle: "Share your thoughts and suggestions",
                    iconColor: AppColors.yellowAccent
                ) {
                    openURL("https://google.com")
                }
            }
        }
    }
    
    private var appVersionSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "lungs.fill")
                .font(.system(size: 40))
                .foregroundColor(AppColors.primaryPurple.opacity(0.7))
            
            Text("Breathora")
                .font(.playfairDisplay(size: 20, weight: .semibold))
                .foregroundColor(AppColors.darkText)
            
            Text("Made with ❤️ for mindful breathing")
                .font(.playfairDisplay(size: 12, weight: .regular))
                .foregroundColor(AppColors.lightText)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 30)
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestAppStoreReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsSectionView<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.playfairDisplay(size: 18, weight: .semibold))
                .foregroundColor(AppColors.darkText)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                content
            }
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .shadow(color: AppColors.darkText.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

struct SettingsRowView: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.playfairDisplay(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.darkText)
                    
                    Text(subtitle)
                        .font(.playfairDisplay(size: 11, weight: .regular))
                        .foregroundColor(AppColors.mediumText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.lightText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

#Preview {
    SettingsView()
}
