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
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            Image(systemName: "lightbulb.fill")
                                .font(.system(size: 60, weight: .light))
                                .foregroundColor(AppColors.primaryYellow)
                            
                            Text("Hobby Ideas")
                                .font(.playfairDisplay(24, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Your personal creative journal")
                                .font(.playfairDisplay(16, weight: .regular))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        .padding(.top, 30)
                        
                        VStack(spacing: 16) {
                            SettingsButton(
                                icon: "star.fill",
                                title: "Rate the App",
                                subtitle: "Help us improve with your feedback"
                            ) {
                                requestReview()
                            }
                            
                            SettingsButton(
                                icon: "doc.text",
                                title: "Terms of Use",
                                subtitle: "Read our terms and conditions"
                            ) {
                                openURL("https://www.privacypolicies.com/live/754af614-fd3d-49e6-a106-9e8fa11096c4")
                            }
                            
                            SettingsButton(
                                icon: "hand.raised.fill",
                                title: "Privacy Policy",
                                subtitle: "Learn about data protection"
                            ) {
                                openURL("https://www.privacypolicies.com/live/9c176cf5-243b-43d4-8c5e-c5a5775a2154")
                            }
                            
                            SettingsButton(
                                icon: "envelope.fill",
                                title: "Contact Us",
                                subtitle: "Get in touch with support"
                            ) {
                                openURL("https://www.privacypolicies.com/live/9c176cf5-243b-43d4-8c5e-c5a5775a2154")
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
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
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(AppColors.primaryYellow)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(AppColors.primaryWhite.opacity(0.2))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(subtitle)
                        .font(.playfairDisplay(14, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}
