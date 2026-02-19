import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var diaryViewModel: DiaryViewModel
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            GridBackgroundView()
            
            ScrollView {
                VStack(spacing: 28) {
                    VStack(spacing: 8) {
                        Image(systemName: "gearshape.2.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [ColorTheme.primaryBlue, ColorTheme.primaryYellow],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        Text("Settings")
                            .font(.ubuntuHeadline())
                            .foregroundColor(ColorTheme.primaryText)
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 8)
                    
                    VStack(spacing: 12) {
                        SettingsRow(
                            icon: "lock.shield.fill",
                            title: "Privacy Policy",
                            subtitle: "Data protection",
                            accentColor: ColorTheme.primaryBlue,
                            action: openPrivacyPolicy
                        )
                        
                        SettingsRow(
                            icon: "envelope.fill",
                            title: "Contact Us",
                            subtitle: "Get in touch",
                            accentColor: ColorTheme.lightGreen,
                            action: openContactEmail
                        )
                        
                        SettingsRow(
                            icon: "star.fill",
                            title: "Rate the App",
                            subtitle: "Share your feedback",
                            accentColor: ColorTheme.primaryYellow,
                            action: rateApp
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 6) {
                        Text("Made with care for your wellbeing")
                            .font(.ubuntuCaption())
                            .foregroundColor(ColorTheme.accentText)
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private func loadSampleData() {
        diaryViewModel.loadSampleData()
    }
    
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://www.privacypolicies.com/live/bab4a264-c174-4b91-b138-a4a8e0d66c1d") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openContactEmail() {
        if let url = URL(string: "https://www.privacypolicies.com/live/bab4a264-c174-4b91-b138-a4a8e0d66c1d") {
            UIApplication.shared.open(url)
        }
    }
    
    private func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let accentColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(accentColor)
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.ubuntuBody())
                        .foregroundColor(ColorTheme.primaryText)
                    Text(subtitle)
                        .font(.ubuntuCaption())
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(ColorTheme.cardBackground)
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(accentColor.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: ColorTheme.cardShadow, radius: 6, x: 0, y: 2)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(DiaryViewModel())
}
