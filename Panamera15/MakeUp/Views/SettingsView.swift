import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                settingsContent
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.bauhausBold(28))
                .foregroundColor(AppColors.white)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var settingsContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                appInfoSection
                
                settingsOptionsSection
                
                footerSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 30)
            .padding(.bottom, 120)
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardGradient)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "paintbrush.pointed.fill")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.purple)
                )
            
            Text("Makeup Ideas")
                .font(.bauhausBold(24))
                .foregroundColor(AppColors.white)
        }
        .padding(.bottom, 20)
    }
    
    private var settingsOptionsSection: some View {
        VStack(spacing: 16) {
            SettingsRow(
                icon: "hand.raised.fill",
                title: "Privacy Policy",
                subtitle: "Learn how we protect your data"
            ) {
                openURL("https://www.termsfeed.com/live/6f0dd5e6-a7f6-44e4-b782-7d7bb631a8db")
            }
            
            SettingsRow(
                icon: "envelope.fill",
                title: "Contact Us",
                subtitle: "Get in touch with our team"
            ) {
                openURL("https://www.termsfeed.com/live/6f0dd5e6-a7f6-44e4-b782-7d7bb631a8db")
            }
            
            SettingsRow(
                icon: "star.fill",
                title: "Rate the App",
                subtitle: "Help us improve with your feedback"
            ) {
                requestReview()
            }
        }
    }
    
    private var footerSection: some View {
        VStack(spacing: 12) {
            Text("Made with ❤️ for makeup enthusiasts")
                .font(.bauhausLight(14))
                .foregroundColor(AppColors.white.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Text("© 2024 Makeup Ideas App")
                .font(.bauhausLight(12))
                .foregroundColor(AppColors.white.opacity(0.5))
        }
        .padding(.top, 40)
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
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.purple)
                    .frame(width: 32, height: 32)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(AppColors.purple.opacity(0.1))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.bauhausMedium(16))
                        .foregroundColor(AppColors.darkGray)
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitle)
                        .font(.bauhausLight(14))
                        .foregroundColor(AppColors.mediumGray)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.mediumGray)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: AppColors.darkGray.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
