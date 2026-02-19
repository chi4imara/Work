import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Settings")
                    .font(FontManager.bauhausBold(28))
                    .foregroundColor(AppColors.primaryText)
                    .padding(.top, 20)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                ScrollView {
                    VStack(spacing: 16) {
                        SettingsCardView(
                            icon: "shield.checkered",
                            title: "Privacy Policy",
                            subtitle: "Read our privacy policy",
                            iconColor: AppColors.primaryBlue,
                            backgroundColor: AppColors.primaryBlue.opacity(0.1)
                        ) {
                            openURL("https://www.privacypolicies.com/live/4b8eae40-5927-4ba2-95a1-00adaa31acb8")
                        }
                        
                        SettingsCardView(
                            icon: "envelope",
                            title: "Contact Us",
                            subtitle: "Get in touch with us",
                            iconColor: AppColors.primaryYellow,
                            backgroundColor: AppColors.primaryYellow.opacity(0.1)
                        ) {
                            openURL("https://www.privacypolicies.com/live/4b8eae40-5927-4ba2-95a1-00adaa31acb8")
                        }
                        
                        SettingsCardView(
                            icon: "star.fill",
                            title: "Rate App",
                            subtitle: "Share your feedback",
                            iconColor: AppColors.accentPink,
                            backgroundColor: AppColors.accentPink.opacity(0.1)
                        ) {
                            requestReview()
                        }
                    }
                    .padding()
                    .padding(.top, 20)
                }
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsCardView: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconColor: Color
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(backgroundColor)
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(FontManager.bauhausMedium(18))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(subtitle)
                        .font(FontManager.bauhausLight(14))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding()
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
    }
}
