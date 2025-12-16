import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 0) {
                        appInfoSection
                        
                        VStack(spacing: 20) {
                            legalSection
                            supportSection
                            ratingSection
                        }
                        .padding(.top, 30)
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(AppColors.purpleGradient)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "paintbrush.fill")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.contrastText)
                )
            
            VStack(spacing: 8) {
                Text("Polished")
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
            }
        }
        .padding(.top, 20)
    }
    
    private var legalSection: some View {
        SettingsSection(title: "Legal") {
            VStack(spacing: 0) {
                SettingsRow(
                    title: "Terms of Use",
                    icon: "doc.text",
                    action: { openURL("https://www.privacypolicies.com/live/ed12271d-2376-4985-afdb-cdb509d7943b") }
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsRow(
                    title: "Privacy Policy",
                    icon: "lock.shield",
                    action: { openURL("https://www.privacypolicies.com/live/2f86c8fd-03aa-49d5-825c-40fa4639c971") }
                )
            }
        }
    }
    
    private var supportSection: some View {
        SettingsSection(title: "Support") {
            VStack(spacing: 0) {
                SettingsRow(
                    title: "Contact Us",
                    icon: "envelope",
                    action: { openURL("https://www.privacypolicies.com/live/2f86c8fd-03aa-49d5-825c-40fa4639c971") }
                )
            }
        }
    }
    
    private var ratingSection: some View {
        SettingsSection(title: "Feedback") {
            SettingsRow(
                title: "Rate the App",
                icon: "star",
                action: { requestReview() }
            )
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
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 16)
            
            VStack(spacing: 0) {
                content
            }
            .background(AppColors.backgroundWhite.opacity(0.8))
            .cornerRadius(16)
            .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(AppColors.yellowAccent)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.playfairDisplay(16))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
    }
}
