import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var dataManager: EmotionDataManager
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.poppinsBold(size: 24))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        VStack(spacing: 16) {
                            SettingsButton(
                                icon: "doc.text",
                                title: "Terms and Conditions",
                                subtitle: "Read our terms of service"
                            ) {
                                openURL("https://docs.google.com/document/d/1mDqCqjuHfwfvuf55Q73w9T7VbC6-xU7BU3sksMc0NeU/edit?usp=sharing")
                            }
                            
                            SettingsButton(
                                icon: "hand.raised",
                                title: "Privacy Policy",
                                subtitle: "Learn about data protection"
                            ) {
                                openURL("https://docs.google.com/document/d/1luDLCyFGolcZoGzdbsDdcjn_S1Zbc6mUdfYYEUE6SEU/edit?usp=sharing")
                            }
                            
                            SettingsButton(
                                icon: "envelope",
                                title: "Contact Us",
                                subtitle: "Get in touch with support"
                            ) {
                                openURL("https://forms.gle/LmL9ckiZ9jheyBKn7")
                            }
                            
                            SettingsButton(
                                icon: "star",
                                title: "Rate the App",
                                subtitle: "Share your feedback"
                            ) {
                                requestReview()
                            }
                        }
                        
                        VStack(spacing: 8) {
                            Text("Daily Emotion")
                                .font(.poppinsBold(size: 18))
                                .foregroundColor(AppColors.primaryText)
                        }
                        .padding(.top, 30)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 100)
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

struct SettingsButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(AppColors.accentYellow)
                    .frame(width: 40, height: 40)
                    .background(AppColors.accentYellow.opacity(0.2))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.poppinsMedium(size: 16))
                        .foregroundColor(AppColors.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(subtitle)
                        .font(.poppinsRegular(size: 14))
                        .foregroundColor(AppColors.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.primaryText.opacity(0.6))
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView(dataManager: EmotionDataManager())
}
