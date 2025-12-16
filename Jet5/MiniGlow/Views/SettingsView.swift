import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                Text("Settings")
                    .font(.titleLarge)
                    .foregroundColor(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                
                ScrollView {
                    VStack(spacing: 20) {
                        SettingsSection(title: "Legal") {
                            VStack(spacing: 12) {
                                SettingsRow(
                                    icon: "doc.text",
                                    title: "Terms of Use",
                                    action: {
                                        openURL("https://www.privacypolicies.com/live/65cc8ced-f952-44be-9f7d-2246566838c8")
                                    }
                                )
                                
                                SettingsRow(
                                    icon: "hand.raised",
                                    title: "Privacy Policy",
                                    action: {
                                        openURL("https://www.privacypolicies.com/live/6db92e67-cac1-4c05-b5ff-376573f9fb22")
                                    }
                                )
                            }
                        }
                        
                        SettingsSection(title: "Support") {
                            VStack(spacing: 12) {
                                SettingsRow(
                                    icon: "envelope",
                                    title: "Contact Us",
                                    action: {
                                        openURL("https://www.privacypolicies.com/live/6db92e67-cac1-4c05-b5ff-376573f9fb22")
                                    }
                                )
                                
                                SettingsRow(
                                    icon: "star",
                                    title: "Rate App",
                                    action: {
                                        requestReview()
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
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
                .font(.titleSmall)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 0) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    )
            )
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.primaryPurple)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    SettingsView()
}
