import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(AppColors.white)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(spacing: 25) {
                        AppInfoSection()
                        
                        SettingsSection(title: "Support") {
                            SettingsRow(
                                icon: "envelope",
                                title: "Contact Us",
                                subtitle: "Get help and support"
                            ) {
                                openURL("https://www.termsfeed.com/live/850e7521-eda8-4699-a927-d01f3a50d838")
                            }
                            
                            Divider()
                                .overlay {
                                    Color.white
                                }
                                .padding(.horizontal, -20)
                                .frame(maxWidth: .infinity)
                            
                            SettingsRow(
                                icon: "star",
                                title: "Rate App",
                                subtitle: "Share your feedback"
                            ) {
                                requestReview()
                            }
                        }
                        
                        SettingsSection(title: "Legal") {
                            SettingsRow(
                                icon: "doc.text",
                                title: "Privacy Policy",
                                subtitle: "How we protect your data"
                            ) {
                                openURL("https://www.termsfeed.com/live/850e7521-eda8-4699-a927-d01f3a50d838")
                            }
                        }
                        
                        AppVersionView()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 120)
                }

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

struct AppInfoSection: View {
    var body: some View {
        VStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.buttonGradient)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 40, weight: .medium))
                        .foregroundColor(AppColors.white)
                )
            
            VStack(spacing: 8) {
                Text("Body Progress Tracker")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.white)
                
                Text("Track your fitness journey")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.white.opacity(0.7))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .shadow(color: AppColors.darkBlue.opacity(0.3), radius: 8, x: 0, y: 4)
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
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.white)
                .padding(.horizontal, 5)
            
            VStack(spacing: 1) {
                content
            }
            .background(AppColors.cardGradient)
            .cornerRadius(15)
            .shadow(color: AppColors.darkBlue.opacity(0.2), radius: 5, x: 0, y: 2)
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
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.lightBlue)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.white)
                    
                    Text(subtitle)
                        .font(.ubuntu(12))
                        .foregroundColor(AppColors.white.opacity(0.6))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.white.opacity(0.4))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

struct AppVersionView: View {
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Made with ❤️ for fitness enthusiasts")
                .font(.ubuntu(12))
                .foregroundColor(AppColors.white.opacity(0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}

#Preview {
    SettingsView()
}

