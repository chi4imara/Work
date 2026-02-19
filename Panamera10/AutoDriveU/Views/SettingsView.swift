import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                settingsContent
            }
        }
        .alert(isPresented: $showingRateAlert) {
            Alert(
                title: Text("Rate Our App"),
                message: Text("Would you like to rate AutoDriveU in the App Store?"),
                primaryButton: .default(Text("Rate Now")) {
                    requestAppStoreReview()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Settings")
                    .font(FontManager.largeTitle)
                    .foregroundColor(AppColors.primaryWhite)
                
                Text("App preferences and information")
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.primaryWhite.opacity(0.8))
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var settingsContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                appSection
                
                legalSection
                
                supportSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var appSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("App")
                .font(FontManager.title2)
                .foregroundColor(AppColors.primaryWhite)
            
            VStack(spacing: 12) {
                SettingsRow(
                    icon: "star.fill",
                    title: "Rate App",
                    subtitle: "Help us improve by rating the app",
                    iconColor: AppColors.accentYellow
                ) {
                    showingRateAlert = true
                }
            }
        }
    }
    
    private var legalSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Legal")
                .font(FontManager.title2)
                .foregroundColor(AppColors.primaryWhite)
            
            VStack(spacing: 12) {
                SettingsRow(
                    icon: "doc.text.fill",
                    title: "Privacy Policy",
                    subtitle: "How we handle your data",
                    iconColor: AppColors.accentPurple
                ) {
                    openURL("https://doc-hosting.flycricket.io/autodrive-upgrade-privacy-policy/3664f36f-b47b-4079-89ae-845cbb5b982e/privacy")
                }
            }
        }
    }
    
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Support")
                .font(FontManager.title2)
                .foregroundColor(AppColors.primaryWhite)
            
            VStack(spacing: 12) {
                SettingsRow(
                    icon: "envelope.fill",
                    title: "Contact Us",
                    subtitle: "Get in touch with our team",
                    iconColor: AppColors.accentGreen
                ) {
                    openURL("https://forms.gle/avjmeaHEisWcsKzXA")
                }
            }
        }
    }
    
    private func requestAppStoreReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconColor: Color
    var showArrow: Bool = true
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(FontManager.headline)
                        .foregroundColor(AppColors.cardText)
                    
                    Text(subtitle)
                        .font(FontManager.caption2)
                        .foregroundColor(AppColors.cardText.opacity(0.7))
                }
                
                Spacer()
                
                if showArrow {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.cardText.opacity(0.4))
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground)
                    .shadow(color: AppColors.primaryDarkBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    SettingsView()
}
