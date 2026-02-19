import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                headerView
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        appInfoSection
                        
                        settingsOptionsView
                    }
                    .padding(.bottom, 120)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.vertical, 10)
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.lightBlue.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 32))
                    .foregroundColor(AppColors.lightBlue)
            }
            
            VStack(spacing: 4) {
                Text("Pull-up Tracker")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
            }
        }
        .padding(20)
        .cardStyle()
    }
    
    private var settingsOptionsView: some View {
        VStack(spacing: 16) {
            SettingsRow(
                icon: "shield.fill",
                title: "Privacy Policy",
                subtitle: "Learn how we protect your data"
            ) {
                openURL("https://doc-hosting.flycricket.io/risechain-reps-privacy-policy/3c936732-c9f1-4770-8467-a769b2012d7d/privacy")
            }
            
            SettingsRow(
                icon: "envelope.fill",
                title: "Contact Us",
                subtitle: "Get in touch with our team"
            ) {
                openURL("https://forms.gle/scmPWXkHG4FBZoBV7")
            }
            
            SettingsRow(
                icon: "star.fill",
                title: "Rate the App",
                subtitle: "Help us improve with your feedback"
            ) {
                requestReview()
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

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.lightBlue.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(AppColors.lightBlue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(subtitle)
                        .font(.ubuntu(14))
                        .foregroundColor(AppColors.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(16)
            .cardStyle()
        }
    }
}

#Preview {
    SettingsView()
}
