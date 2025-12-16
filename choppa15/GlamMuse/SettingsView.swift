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
                
                ScrollView {
                    VStack(spacing: 20) {
                        SettingsSection(title: "Legal") {
                            SettingsRow(
                                title: "Terms and Conditions",
                                icon: "doc.text",
                                action: { openURL("https://www.freeprivacypolicy.com/live/270cb4b0-dd50-4552-a708-8168fdfdfb8a") }
                            )
                            
                            SettingsRow(
                                title: "Privacy Policy",
                                icon: "hand.raised",
                                action: { openURL("https://www.freeprivacypolicy.com/live/f4cc9504-8a53-4a1b-a04b-9c5729444fc1") }
                            )
                        }
                        
                        SettingsSection(title: "Support") {
                            SettingsRow(
                                title: "Contact Us",
                                icon: "envelope",
                                action: { openURL("https://forms.gle/otNKW2sjgNCNQjDx8") }
                            )
                            
                            SettingsRow(
                                title: "Rate App",
                                icon: "star",
                                action: { requestReview() }
                            )
                        }
                        
                        appInfoView
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    .padding(.bottom, 100)
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Settings")
                .font(.ubuntu(32, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text("App preferences and information")
                .font(.ubuntu(16))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }
    
    private var appInfoView: some View {
        VStack(spacing: 12) {
            Image(systemName: "paintbrush.pointed")
                .font(.system(size: 40))
                .foregroundColor(AppColors.primaryText)
            
            Text("GlamMuse")
                .font(.ubuntu(20, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            Text("Keep your makeup ideas organized")
                .font(.ubuntu(14))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 30)
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
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 4)
            
            VStack(spacing: 1) {
                content
            }
            .background(AppColors.cardBackground)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
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
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.accent)
                    .frame(width: 24)
                
                Text(title)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.darkText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.darkText.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(AppColors.cardBackground)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}
