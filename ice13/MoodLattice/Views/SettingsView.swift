import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            ScrollView {
                VStack(spacing: 25) {
                    headerView
                    
                    VStack(spacing: 20) {
                        appSectionView
                        
                        legalSectionView
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 15) {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [AppColors.accent, AppColors.primaryText]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "heart.fill")
                        .font(.system(size: 40, weight: .medium))
                        .foregroundColor(.white)
                )
            
            VStack(spacing: 5) {
                Text("MoodLattice")
                    .font(FontManager.ubuntu(size: 24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Track your daily mood")
                    .font(FontManager.ubuntu(size: 16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 8)
        )
    }
    
    private var appSectionView: some View {
        SettingsSection(title: "App") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "star.fill",
                    title: "Rate App",
                    iconColor: AppColors.accent,
                    showArrow: true
                ) {
                    requestAppReview()
                }
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsRow(
                    icon: "envelope.fill",
                    title: "Contact Us",
                    iconColor: AppColors.accent,
                    showArrow: true
                ) {
                    openURL("https://www.termsfeed.com/live/bb3c86b2-9978-4306-94a6-44976f802729")
                }
            }
        }
    }
    
    private var legalSectionView: some View {
        SettingsSection(title: "Legal") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "doc.text.fill",
                    title: "Terms of Use",
                    iconColor: AppColors.primaryText,
                    showArrow: true
                ) {
                    openURL("https://www.termsfeed.com/live/addfe376-302e-48fb-996d-1d3f37d3e3e4")
                }
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsRow(
                    icon: "lock.fill",
                    title: "Privacy Policy",
                    iconColor: AppColors.primaryText,
                    showArrow: true
                ) {
                    openURL("https://www.termsfeed.com/live/bb3c86b2-9978-4306-94a6-44976f802729")
                }
            }
        }
    }
    
    private var supportSectionView: some View {
        SettingsSection(title: "Support") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "envelope.fill",
                    title: "Contact Us",
                    iconColor: AppColors.accent,
                    subtitle: "support@moodlattice.com",
                    showArrow: true
                ) {
                    openURL("https://google.com")
                }
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsRow(
                    icon: "questionmark.circle.fill",
                    title: "Help & FAQ",
                    iconColor: AppColors.info,
                    showArrow: true
                ) {
                    openURL("https://google.com")
                }
            }
        }
    }
    
    private func requestAppReview() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
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
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(FontManager.ubuntu(size: 20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(AppColors.cardBackground)
                    .shadow(color: AppColors.shadowColor, radius: 5)
            )
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    var subtitle: String? = nil
    let showArrow: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(FontManager.ubuntu(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(FontManager.ubuntu(size: 14, weight: .regular))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
                
                Spacer()
                
                if showArrow {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText.opacity(0.6))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    SettingsView()
}
