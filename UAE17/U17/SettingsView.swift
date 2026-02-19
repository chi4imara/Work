import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    private let settings: [SettingItem] = [
        SettingItem(title: "Privacy Policy", icon: "shield.fill", color: Color.theme.lightBlue),
        SettingItem(title: "Contact Us", icon: "envelope.fill", color: Color.theme.green),
        SettingItem(title: "Rate App", icon: "star.fill", color: Color.theme.orange)
    ]
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Settings")
                    .font(.playfairDisplay(32, weight: .bold))
                    .foregroundColor(Color.theme.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 12) {
                            ForEach(settings, id: \.title) { setting in
                                SettingRowView(setting: setting) {
                                    handleSettingAction(setting.title)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        additionalInfoSection
                            .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private func handleSettingAction(_ title: String) {
        switch title {
        case "Privacy Policy":
            openURL("https://www.privacypolicies.com/live/4876a13d-1f9b-4ff0-8352-b5575add5f14")
        case "Contact Us":
            openURL("https://www.privacypolicies.com/live/4876a13d-1f9b-4ff0-8352-b5575add5f14")
        case "Rate App":
            requestReview()
        default:
            break
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func shareApp() {
        let activityVC = UIActivityViewController(
            activityItems: ["Check out this amazing garage tool organizer app!"],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "wrench.and.screwdriver.fill")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(Color.theme.orange)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Garage Tool Organizer")
                        .font(.playfairDisplay(20, weight: .bold))
                        .foregroundColor(Color.theme.white)
                    
                    Text("Version 1.0.0")
                        .font(.playfairDisplay(14))
                        .foregroundColor(Color.theme.white.opacity(0.7))
                }
                
                Spacer()
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.theme.cardGradient)
            )
            
            VStack(spacing: 12) {
                InfoRow(icon: "doc.text.fill", title: "Build", value: "1.0.0")
                InfoRow(icon: "calendar", title: "Release Date", value: "2025")
                InfoRow(icon: "iphone", title: "Platform", value: "iOS 16.0+")
            }
        }
    }
    
    private var additionalInfoSection: some View {
        VStack(spacing: 16) {
            Text("App Information")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(Color.theme.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                InfoCard(
                    icon: "sparkles",
                    title: "Features",
                    description: "Organize your garage tools, track usage, and maintain your inventory efficiently."
                )
                
                InfoCard(
                    icon: "lock.shield.fill",
                    title: "Privacy",
                    description: "Your data is stored locally on your device. We don't collect any personal information."
                )
                
                InfoCard(
                    icon: "heart.fill",
                    title: "Made with Care",
                    description: "Designed to help you keep your garage organized and your tools accessible."
                )
            }
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color.theme.lightBlue)
                .frame(width: 24)
            
            Text(title)
                .font(.playfairDisplay(16))
                .foregroundColor(Color.theme.white.opacity(0.8))
            
            Spacer()
            
            Text(value)
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(Color.theme.orange)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.cardGradient)
        )
    }
}

struct InfoCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(Color.theme.orange)
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(Color.theme.orange.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(Color.theme.white)
                
                Text(description)
                    .font(.playfairDisplay(14))
                    .foregroundColor(Color.theme.white.opacity(0.7))
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.theme.cardGradient)
        )
    }
}

struct SettingItem {
    let title: String
    let icon: String
    let color: Color
}

struct SettingRowView: View {
    let setting: SettingItem
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: setting.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(setting.color)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(setting.color.opacity(0.2))
                    )
                
                Text(setting.title)
                    .font(.playfairDisplay(18, weight: .medium))
                    .foregroundColor(Color.theme.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.theme.white.opacity(0.5))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.theme.cardGradient)
            )
        }
    }
}

#Preview {
    SettingsView()
}
