import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 24) {
                        legalSection
                        
                        supportSection
                        
                        appSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(AppFonts.largeTitle(.bold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var legalSection: some View {
        SettingsSection(title: "Legal") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "doc.text",
                    title: "Terms of Use",
                    action: { openURL("https://www.termsfeed.com/live/095a1756-6d62-42f2-9eed-4971546933ad") }
                )
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsRow(
                    icon: "hand.raised",
                    title: "Privacy Policy",
                    action: { openURL("https://www.termsfeed.com/live/910fb965-13ef-4f54-8aaf-499638bc10e5") }
                )
            }
        }
    }
    
    private var supportSection: some View {
        SettingsSection(title: "Support") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "envelope",
                    title: "Contact Us",
                    action: { openURL("https://www.termsfeed.com/live/910fb965-13ef-4f54-8aaf-499638bc10e5") }
                )
            }
        }
    }
    
    private var appSection: some View {
        SettingsSection(title: "App") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "star",
                    title: "Rate App",
                    action: { requestAppReview() }
                )
            }
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

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(AppFonts.title3(.semiBold))
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                content
            }
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String?
    let action: () -> Void
    
    init(icon: String, title: String, subtitle: String? = nil, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.primaryBlue.opacity(0.1))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(AppFonts.body(.medium))
                        .foregroundColor(AppColors.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(AppFonts.caption(.regular))
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                
                Spacer()
                
                if subtitle == nil {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(AppColors.textTertiary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

#Preview {
    SettingsView()
}
