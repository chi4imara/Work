import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                Text("Settings")
                    .font(.appTitle)
                    .foregroundColor(.appText)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 8)
                
                ScrollView {
                    VStack(spacing: 24) {
                        SettingsSection(title: "App") {
                            VStack(spacing: 12) {
                                SettingsRow(
                                    icon: "star.fill",
                                    title: "Rate App",
                                    subtitle: "Help us improve",
                                    action: {
                                        requestReview()
                                    }
                                )
                            }
                        }
                        
                        SettingsSection(title: "Legal") {
                            VStack(spacing: 12) {
                                SettingsRow(
                                    icon: "doc.text.fill",
                                    title: "Terms of Use",
                                    subtitle: "Read our terms",
                                    action: {
                                        openURL("https://docs.google.com/document/d/18QVX5Abhd9ZJ-kVNqXYzHtU_Odf-g3EEtZ5Sp_13Rhc/edit?usp=sharing")
                                    }
                                )
                                
                                Divider()
                                    .frame(maxWidth: .infinity)
                                
                                SettingsRow(
                                    icon: "hand.raised.fill",
                                    title: "Privacy Policy",
                                    subtitle: "Your privacy matters",
                                    action: {
                                        openURL("https://docs.google.com/document/d/1xGnNWdX6z91j66AWIShXX_97k9H74F8RbbuuM4o7_XU/edit?usp=sharing")
                                    }
                                )
                            }
                        }
                        
                        SettingsSection(title: "Contact") {
                            VStack(spacing: 12) {
                                SettingsRow(
                                    icon: "envelope.fill",
                                    title: "Contact Us",
                                    subtitle: "Get in touch",
                                    action: {
                                        openURL("https://forms.gle/KXVSBEC4KAmzHYqDA")
                                    }
                                )
                            }
                        }
                        
                        VStack(spacing: 8) {
                            Text("SmartDesk")
                                .font(.appSubheadline)
                                .foregroundColor(.appText)
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
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

struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.appHeadline)
                .foregroundColor(.appText)
            
            VStack(spacing: 1) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
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
                    .font(.title3)
                    .foregroundColor(AppColors.primaryBlue)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.appSubheadline)
                        .foregroundColor(.appText)
                    
                    Text(subtitle)
                        .font(.appCaption)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.clear)
        }
    }
}

#Preview {
    SettingsView()
}
