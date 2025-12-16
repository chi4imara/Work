import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            AppGradients.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Settings")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        SettingsSectionView(title: "App") {
                            VStack(spacing: 0) {
                                SettingsRowView(
                                    title: "Rate App",
                                    icon: "star.fill",
                                    iconColor: .primaryYellow
                                ) {
                                    requestReview()
                                }
                                
                                Divider()
                                    .background(Color.white.opacity(0.1))
                                    .padding(.horizontal, 16)
                                
                                SettingsRowView(
                                    title: "Contact Us",
                                    icon: "envelope.fill",
                                    iconColor: .blue
                                ) {
                                    openURL("https://www.termsfeed.com/live/8743bc0c-857d-479f-b282-e4a31a6b4222")
                                }
                            }
                        }
                        
                        SettingsSectionView(title: "Legal") {
                            VStack(spacing: 0) {
                                SettingsRowView(
                                    title: "Terms of Use",
                                    icon: "doc.text.fill",
                                    iconColor: .primaryPurple
                                ) {
                                    openURL("https://www.termsfeed.com/live/0009bb1f-01fc-41ea-a02a-a377c632075a")
                                }
                                
                                Divider()
                                    .background(Color.white.opacity(0.1))
                                    .padding(.horizontal, 16)
                                
                                SettingsRowView(
                                    title: "Privacy Policy",
                                    icon: "lock.fill",
                                    iconColor: .accentGreen
                                ) {
                                    openURL("https://www.termsfeed.com/live/8743bc0c-857d-479f-b282-e4a31a6b4222")
                                }
                            }
                        }
                        
                        SettingsSectionView(title: "About") {
                            VStack(spacing: 16) {
                                HStack {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 24))
                                        .foregroundColor(.primaryYellow)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("AuraLog")
                                            .font(.ubuntu(18, weight: .medium))
                                            .foregroundColor(.primaryText)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                
                                Text("Your personal fragrance catalog. Track, organize, and discover your scent preferences.")
                                    .font(.ubuntu(14))
                                    .foregroundColor(.secondaryText)
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal, 16)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
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
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(.primaryText)
                .padding(.horizontal, 4)
            
            content
                .background(AppGradients.cardGradient)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        }
    }
}

struct SettingsRowView: View {
    let title: String
    let icon: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(iconColor)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
    }
}
