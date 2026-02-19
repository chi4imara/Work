import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    @Environment(\.requestReview) var requestReview

    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Settings")
                    .font(.playfairDisplay(size: 32, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                
                ScrollView {
                    VStack(spacing: 20) {
                        SettingsSection(title: "App Information") {
                            VStack(spacing: 0) {
                                SettingsRow(
                                    icon: "star.circle",
                                    title: "Rate App",
                                    subtitle: "Help us improve",
                                    action: {
                                        requestReview()
                                    }
                                )
                                
                                Divider()
                                    .background(ColorManager.lightBlue.opacity(0.3))
                                    .padding(.leading, 60)
                                
                                SettingsRow(
                                    icon: "envelope.circle",
                                    title: "Contact Us",
                                    subtitle: "Get in touch",
                                    action: {
                                        openURL("https://www.privacypolicies.com/live/983cadfb-fdc7-4d1c-af8c-dff463829428")
                                    }
                                )
                            }
                        }
                        
                        SettingsSection(title: "Legal") {
                            SettingsRow(
                                icon: "doc.text.fill",
                                title: "Privacy Policy",
                                subtitle: "Your data protection",
                                action: {
                                    openURL("https://www.privacypolicies.com/live/983cadfb-fdc7-4d1c-af8c-dff463829428")
                                }
                            )
                        }
                        
                        VStack(spacing: 8) {
                            Text("Watch Catalog")
                                .font(.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(ColorManager.primaryText)
                        }
                        .padding(.top, 30)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
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
                .font(.playfairDisplay(size: 18, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                content
            }
            .background(ColorManager.cardGradient)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(ColorManager.lightBlue.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
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
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(ColorManager.lightBlue)
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.playfairDisplay(size: 16, weight: .semibold))
                        .foregroundColor(ColorManager.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitle)
                        .font(.playfairDisplay(size: 14, weight: .regular))
                        .foregroundColor(ColorManager.secondaryText)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.lightBlue)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    SettingsView()
}
