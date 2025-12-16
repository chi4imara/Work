import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                settingsContentView
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(AppFonts.title1)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.top, 20)
        .padding(.bottom, 20)
    }
    
    private var settingsContentView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                appSectionView
                
                legalSectionView
                
                supportSectionView
            }
            .padding(.bottom, 200)
        }
        .padding(.bottom, -100)
    }
    
    private var appSectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("App")
                .font(AppFonts.title3)
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "star.fill",
                    title: "Rate App",
                    subtitle: "Help us improve",
                    iconColor: AppColors.yellow
                ) {
                    requestReview()
                }
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private var legalSectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Legal")
                .font(AppFonts.title3)
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "doc.text",
                    title: "Terms of Use",
                    subtitle: "User agreement",
                    iconColor: Color.blue
                ) {
                    openURL("https://www.termsfeed.com/live/cc4d70b1-4e29-4846-8be5-b35f49adf0d4")
                }
                
                Divider()
                    .background(AppColors.primaryText.opacity(0.1))
                    .padding(.horizontal, 16)
                
                SettingsRow(
                    icon: "lock.shield",
                    title: "Privacy Policy",
                    subtitle: "Data protection",
                    iconColor: AppColors.success
                ) {
                    openURL("https://www.termsfeed.com/live/cfe4dd51-abd8-4abd-88a6-50fa7d2d08db")
                }
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
    }
    
    private var supportSectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Support")
                .font(AppFonts.title3)
                .foregroundColor(AppColors.primaryText)
            
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "envelope",
                    title: "Contact Us",
                    subtitle: "Get help and support",
                    iconColor: AppColors.warning
                ) {
                    openURL("https://www.termsfeed.com/live/cfe4dd51-abd8-4abd-88a6-50fa7d2d08db")
                }
            }
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
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
    let subtitle: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(iconColor)
                    .frame(width: 32, height: 32)
                    .background(iconColor.opacity(0.15))
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(AppFonts.bodyBold)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(subtitle)
                        .font(AppFonts.footnote)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}
