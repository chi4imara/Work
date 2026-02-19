import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 0) {
                        VStack(spacing: 16) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 50, weight: .light))
                                .foregroundColor(AppColors.primaryBlue)
                            
                            Text("Settings")
                                .font(.playfairDisplay(28, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                        }
                        .padding(.vertical, 30)
                        
                        VStack(spacing: 24) {
                            SettingsSection(title: "Legal") {
                                VStack(spacing: 1) {
                                    SettingsRow(
                                        icon: "doc.text",
                                        title: "Terms & Conditions",
                                        action: { openURL("https://www.termsfeed.com/live/1406d702-cfc0-4e7d-b629-7dd3b71946ba") }
                                    )
                                    
                                    SettingsRow(
                                        icon: "hand.raised",
                                        title: "Privacy Policy",
                                        action: { openURL("https://www.termsfeed.com/live/b49560fe-a521-4764-83f7-c3418d9ecb1d") }
                                    )
                                }
                            }
                            
                            SettingsSection(title: "Support") {
                                VStack(spacing: 1) {
                                    SettingsRow(
                                        icon: "envelope",
                                        title: "Contact Us",
                                        action: { openURL("https://www.termsfeed.com/live/b49560fe-a521-4764-83f7-c3418d9ecb1d") }
                                    )
                                    
                                    SettingsRow(
                                        icon: "star",
                                        title: "Rate the App",
                                        action: { requestReview() }
                                    )
                                }
                            }
                            
                            VStack(spacing: 8) {
                                Text("Makeup Organizer")
                                    .font(.playfairDisplay(16, weight: .semibold))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text("Made with ♥ for beauty enthusiasts")
                                    .font(.playfairDisplay(12))
                                    .foregroundColor(AppColors.secondaryText)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 8)
                            }
                            .padding(.vertical, 20)
                        }
                        .padding(.horizontal, 20)
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
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 4)
            
            content
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
                    .font(.title3)
                    .foregroundColor(AppColors.primaryBlue)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(AppColors.contrastText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(AppColors.backgroundWhite.opacity(0.9))
        }
    }
}
