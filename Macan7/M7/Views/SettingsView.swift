import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    var body: some View {
        ZStack {
            StaticBackground()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        appSection
                        
                        legalSection
                        
                        contactSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(.appPrimaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var appSection: some View {
        VStack(spacing: 0) {
            SettingsRow(
                icon: "star.fill",
                title: "Rate App",
                subtitle: "Help us improve",
                iconColor: .appYellow
            ) {
                requestReview()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .appPrimary.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
    
    private var legalSection: some View {
        VStack(spacing: 0) {
            SettingsRow(
                icon: "doc.text.fill",
                title: "Terms of Use",
                subtitle: "Legal agreement",
                iconColor: .appPrimary,
                showDivider: true
            ) {
                openURL("https://www.termsfeed.com/live/158475e6-cc6c-4c49-ba83-7fa65761fcc4")
            }
            
            SettingsRow(
                icon: "lock.shield.fill",
                title: "Privacy Policy",
                subtitle: "Data protection",
                iconColor: .appDarkBlue
            ) {
                openURL("https://www.termsfeed.com/live/be06e082-e76e-4b88-95d2-4fa45800e41e")
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .appPrimary.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
    
    private var contactSection: some View {
        VStack(spacing: 0) {
            SettingsRow(
                icon: "envelope.fill",
                title: "Contact Us",
                subtitle: "Get in touch",
                iconColor: .appGreen
            ) {
                openURL("https://www.termsfeed.com/live/be06e082-e76e-4b88-95d2-4fa45800e41e")
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .appPrimary.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
    
    private func requestReview() {
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

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconColor: Color
    var showDivider: Bool = false
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: action) {
                HStack(spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(iconColor.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: icon)
                            .font(.system(size: 18))
                            .foregroundColor(iconColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(.appPrimaryText)
                        
                        Text(subtitle)
                            .font(.ubuntu(14))
                            .foregroundColor(.appSecondaryText)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.appSecondaryText)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            
            if showDivider {
                Divider()
                    .padding(.leading, 76)
            }
        }
    }
}

#Preview {
    SettingsView()
}
