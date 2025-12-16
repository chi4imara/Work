import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
            ZStack {
                BackgroundGradient()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Settings")
                            .font(AppFonts.largeTitle)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            SettingsSectionView(title: "App") {
                                VStack(spacing: 0) {
                                    SettingsRowView(
                                        icon: "star.fill",
                                        title: "Rate App",
                                        subtitle: "Help us improve",
                                        showArrow: true
                                    ) {
                                        requestAppReview()
                                    }
                                    
                                    Divider()
                                        .background(Color.white.opacity(0.2))
                                        .padding(.leading, 60)
                                    
                                    SettingsRowView(
                                        icon: "envelope.fill",
                                        title: "Contact Us",
                                        subtitle: "Get in touch",
                                        showArrow: true
                                    ) {
                                        openURL("https://www.privacypolicies.com/live/fc64bbd6-8d6d-4462-aaf7-a2995ffa104a")
                                    }
                                }
                            }
                            
                            SettingsSectionView(title: "Legal") {
                                VStack(spacing: 0) {
                                    SettingsRowView(
                                        icon: "doc.text.fill",
                                        title: "Terms of Use",
                                        subtitle: "User agreement",
                                        showArrow: true
                                    ) {
                                        openURL("https://www.privacypolicies.com/live/a0ee3f64-09ed-42f6-ba76-e57abd9d58f3")
                                    }
                                    
                                    Divider()
                                        .background(Color.white.opacity(0.2))
                                        .padding(.leading, 60)
                                    
                                    SettingsRowView(
                                        icon: "lock.shield.fill",
                                        title: "Privacy Policy",
                                        subtitle: "Data protection",
                                        showArrow: true
                                    ) {
                                        openURL("https://www.privacypolicies.com/live/fc64bbd6-8d6d-4462-aaf7-a2995ffa104a")
                                    }
                                }
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                    }
                }
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
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                content
            }
            .background(CardBackground())
            .cornerRadius(16)
        }
    }
}

struct SettingsRowView: View {
    let icon: String
    let title: String
    let subtitle: String
    let showArrow: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.primaryYellow.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.primaryYellow)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitle)
                        .font(AppFonts.subheadline)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                if showArrow {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

struct SettingsInfoRowView: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryPurple.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.primaryPurple)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.leading)
                
                Text(value)
                    .font(AppFonts.subheadline)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

