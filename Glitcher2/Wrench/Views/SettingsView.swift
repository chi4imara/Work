import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            ColorManager.primaryBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    Text("Settings")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                        .padding(.vertical, 10)
                    
                    VStack(spacing: 16) {
                        SettingsSection(title: "Legal & Privacy") {
                            SettingsRow(
                                icon: "lock.shield.fill",
                                title: "Privacy Policy",
                                color: ColorManager.lightBlue,
                                action: openPrivacyPolicy
                            )
                        }
                        
                        SettingsSection(title: "Support & Feedback") {
                            SettingsRow(
                                icon: "envelope.fill",
                                title: "Contact Us",
                                color: ColorManager.orange,
                                action: openContactUs
                            )
                        }
                        
                        SettingsSection(title: "App") {
                            SettingsRow(
                                icon: "star.fill",
                                title: "Rate App",
                                color: ColorManager.success,
                                action: rateApp
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
    }
    
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://www.freeprivacypolicy.com/live/5dbe4973-911d-4b74-a92f-cb6fe9eddf9b") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openContactUs() {
        if let url = URL(string: "https://forms.gle/frf1CM3Hoh5ooQhn7") {
            UIApplication.shared.open(url)
        }
    }
    
    private func rateApp() {
        requestReview()
    }
    
    private func openDataProtection() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openAppInfo() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openHelp() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openFeedback() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openSupport() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openAbout() {
        if let url = URL(string: "https://google.com") {
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
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorManager.primaryText.opacity(0.8))
                .padding(.horizontal, 4)
                .padding(.bottom, 4)
            
            VStack(spacing: 12) {
                content
            }
        }
        .padding(.bottom, 24)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [color, color.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText.opacity(0.5))
            }
            .padding(16)
            .background(ColorManager.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: color.opacity(0.1), radius: 8, x: 0, y: 4)
        }
    }
}

#Preview {
    SettingsView()
}
