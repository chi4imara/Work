import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Settings")
                        .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Manage your preferences")
                        .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                }
                .padding(.top, 20)
                .padding(.bottom, 30)
                
                ScrollView {
                    VStack(spacing: 12) {
                        SettingsRow(
                            title: "Privacy Policy",
                            icon: "lock.shield.fill",
                            iconColor: AppColors.accentBlue,
                            action: {
                                openURL("https://www.termsfeed.com/live/7c8b7714-4c42-48fd-9c3b-6d8b5ce424a3")
                            }
                        )
                        
                        SettingsRow(
                            title: "Contact Email",
                            icon: "envelope.fill",
                            iconColor: AppColors.accentOrange,
                            action: {
                                openURL("https://www.termsfeed.com/live/7c8b7714-4c42-48fd-9c3b-6d8b5ce424a3")
                            }
                        )
                        
                        SettingsRow(
                            title: "Rate App",
                            icon: "star.fill",
                            iconColor: AppColors.accentPurple,
                            action: {
                                requestReview()
                            }
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(12)
        }
    }
}

#Preview {
    SettingsView()
}
