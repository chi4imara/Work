import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showRateApp = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 8) {
                        Text("Settings")
                            .font(.nunitoBold(size: 32))
                            .foregroundColor(Color.theme.primaryText)
                        
                        Text("App preferences and information")
                            .font(.nunitoRegular(size: 16))
                            .foregroundColor(Color.theme.secondaryText)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 24) {
                        SettingsSection(title: "App") {
                            VStack(spacing: 0) {
                                SettingsRow(
                                    icon: "star.fill",
                                    title: "Rate App",
                                    iconColor: Color.theme.accentYellow
                                ) {
                                    requestReview()
                                }
                                
                                Divider()
                                    .background(Color.theme.cardBorder)
                                    .padding(.leading, 50)
                                
                                SettingsRow(
                                    icon: "envelope.fill",
                                    title: "Contact Us",
                                    iconColor: Color.theme.accentOrange
                                ) {
                                    openURL("https://forms.gle/pG5ryv8NBCAcahQE6")
                                }
                            }
                        }
                        
                        SettingsSection(title: "Legal") {
                            VStack(spacing: 0) {
                                SettingsRow(
                                    icon: "doc.text.fill",
                                    title: "Terms of Use",
                                    iconColor: Color.theme.accentPurple
                                ) {
                                    openURL("https://docs.google.com/document/d/1s6vmb2cJ0zc3BP3uKKrigGuVOPl3sEQwx5MHIf6lY6Y/edit?usp=sharing")
                                }
                                
                                Divider()
                                    .background(Color.theme.cardBorder)
                                    .padding(.leading, 50)
                                
                                SettingsRow(
                                    icon: "shield.fill",
                                    title: "Privacy Policy",
                                    iconColor: Color.theme.accentGreen
                                ) {
                                    openURL("https://docs.google.com/document/d/1zFUfBeRfYekUJeN3OH7aYkenf6CG6k2n7wynjEqUKTk/edit?usp=sharing")
                                }
                            }
                        }
                        
                        AppInfoView()
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 100)
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
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.nunitoBold(size: 18))
                .foregroundColor(Color.theme.primaryText)
                .padding(.horizontal, 4)
            
            content
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.theme.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.theme.cardBorder, lineWidth: 1)
                        )
                )
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.nunitoMedium(size: 16))
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.theme.tertiaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

struct AppInfoView: View {
    var body: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Color.theme.accentOrange, Color.theme.accentYellow],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "party.popper.fill")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundColor(.white)
                )
            
            VStack(spacing: 8) {
                Text("Party Tasks")
                    .font(.nunitoBold(size: 20))
                    .foregroundColor(Color.theme.primaryText)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                )
        )
    }
}

#Preview {
    SettingsView()
}
