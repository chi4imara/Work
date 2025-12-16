import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Settings")
                .font(FontManager.ubuntu(28, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            ScrollView {
                VStack(spacing: 24) {
                    SettingsSection(title: "Legal") {
                        VStack(spacing: 12) {
                            SettingsRow(
                                icon: "doc.text",
                                title: "Terms of Use",
                                action: {
                                    openURL("https://www.privacypolicies.com/live/0d7b834d-2d46-4643-80df-193fc3f78e9c")
                                }
                            )
                            
                            Divider()
                                .frame(maxWidth: .infinity)
                            
                            SettingsRow(
                                icon: "hand.raised",
                                title: "Privacy Policy",
                                action: {
                                    openURL("https://www.privacypolicies.com/live/da3ac6ac-9045-4ba7-a744-b4d7b737fb85")
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
                                    openURL("https://www.privacypolicies.com/live/da3ac6ac-9045-4ba7-a744-b4d7b737fb85")
                                }
                            )
                            
                            Divider()
                                .frame(maxWidth: .infinity)
                            
                            SettingsRow(
                                icon: "star",
                                title: "Rate App",
                                action: {
                                    requestReview()
                                }
                            )
                        }
                    }
                    
                    VStack(spacing: 8) {
                        Text("HerList")
                            .font(FontManager.ubuntu(16, weight: .bold))
                            .foregroundColor(Color.theme.primaryText)
                        
                        Text("Collect your daily inspiration")
                            .font(FontManager.ubuntu(12))
                            .foregroundColor(Color.theme.secondaryText)
                            .italic()
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 120)
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
                .font(FontManager.ubuntu(18, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 1) {
                content
            }
            .background(Color.theme.cardBackground)
            .cornerRadius(12)
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
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.theme.buttonPrimary)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(FontManager.ubuntu(16))
                    .foregroundColor(Color.theme.darkText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.theme.grayText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.clear)
        }
    }
}

#Preview {
    SettingsView()
}
