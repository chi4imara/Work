import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Settings")
                    .font(.playfairDisplay(.bold, size: 32))
                    .foregroundColor(AppColors.white)
                    .padding(.vertical, 20)
                
                ScrollView {
                    VStack(spacing: 15) {
                        SettingsListItem(
                            icon: "shield.checkered",
                            title: "Privacy Policy",
                            iconColor: AppColors.lightBlue,
                            action: openPrivacyPolicy
                        )
                        
                        SettingsListItem(
                            icon: "envelope.fill",
                            title: "Contact Email",
                            iconColor: AppColors.green,
                            action: contactUs
                        )
                        
                        SettingsListItem(
                            icon: "star.fill",
                            title: "Rate App",
                            iconColor: AppColors.orange,
                            action: rateApp
                        )
                        
                        VStack(spacing: 8) {
                            Image(systemName: "figure.strengthtraining.traditional")
                                .font(.system(size: 30))
                                .foregroundColor(AppColors.orange)
                            
                            Text("Fitness Tracker")
                                .font(.playfairDisplay(.semiBold, size: 16))
                                .foregroundColor(AppColors.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://www.termsfeed.com/live/91218a54-6c0d-421e-91a1-9876d482c95d") {
            UIApplication.shared.open(url)
        }
    }
    
    private func rateApp() {
        requestReview()
    }
    
    private func contactUs() {
        if let url = URL(string: "https://www.termsfeed.com/live/91218a54-6c0d-421e-91a1-9876d482c95d") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openDataProtection() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openTermsOfUse() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openHelpCenter() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func sendFeedback() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsListItem: View {
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.playfairDisplay(.medium, size: 16))
                    .foregroundColor(AppColors.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.white.opacity(0.5))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(AppColors.cardGradient)
            .cornerRadius(15)
        }
    }
}

#Preview {
    SettingsView()
}
