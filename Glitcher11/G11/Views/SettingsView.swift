import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        settingsSection(title: "App") {
                            SettingsRow(
                                icon: "star.fill",
                                title: "Rate App",
                                action: {
                                    requestReview()
                                }
                            )
                        }
                        
                        settingsSection(title: "Legal") {
                            SettingsRow(
                                icon: "shield.fill",
                                title: "Privacy Policy",
                                action: {
                                    openURL("https://www.freeprivacypolicy.com/live/d325ffae-b545-47cc-8ee3-e8808a04cf50")
                                }
                            )
                        }
                        
                        settingsSection(title: "Support") {
                            SettingsRow(
                                icon: "envelope.fill",
                                title: "Contact Us",
                                action: {
                                    openURL("https://forms.gle/UUfpavsBDDxGZYsH6")
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
                .padding(.horizontal, 4)
            
            VStack(spacing: 1) {
                content()
            }
            .background(ColorTheme.cardGradient)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(ColorTheme.accent.opacity(0.2), lineWidth: 1)
            )
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
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(ColorTheme.lightBlue)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    SettingsView()
}
