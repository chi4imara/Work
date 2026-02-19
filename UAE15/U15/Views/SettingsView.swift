import SwiftUI
import StoreKit

struct SettingsView: View {
    var body: some View {
        ZStack {
            ColorManager.shared.primaryBackground
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(FontManager.playfairBold(size: 32))
                        .foregroundColor(ColorManager.shared.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 10)
                
                ScrollView {
                    VStack(spacing: 0) {
                        VStack(spacing: 0) {
                            SettingsRow(
                                icon: "shield.fill",
                                title: "Privacy Policy",
                                iconColor: ColorManager.shared.accentBlue
                            ) {
                                openURL("https://www.privacypolicies.com/live/e8ea0e58-8670-4da3-9922-2303f9abd3e8")
                            }
                            
                            Divider()
                                .background(ColorManager.shared.secondaryText.opacity(0.3))
                                .padding(.leading, 60)
                            
                            SettingsRow(
                                icon: "envelope.fill",
                                title: "Contact Email",
                                iconColor: ColorManager.shared.accentOrange
                            ) {
                                openURL("https://www.privacypolicies.com/live/e8ea0e58-8670-4da3-9922-2303f9abd3e8")
                            }
                            
                            Divider()
                                .background(ColorManager.shared.secondaryText.opacity(0.3))
                                .padding(.leading, 60)
                            
                            SettingsRow(
                                icon: "star.fill",
                                title: "Rate App",
                                iconColor: ColorManager.shared.warningColor
                            ) {
                                requestReview()
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(ColorManager.shared.cardBackground)
                        )
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 20) {
                            VStack(spacing: 12) {
                                Image(systemName: "scissors")
                                    .font(.system(size: 40, weight: .light))
                                    .foregroundColor(ColorManager.shared.secondaryText)
                                
                                Text("Barber Journal")
                                    .font(FontManager.playfairSemiBold(size: 18))
                                    .foregroundColor(ColorManager.shared.primaryText)
                                
                                Text("© 2025 Barber Journal")
                                    .font(FontManager.playfairRegular(size: 12))
                                    .foregroundColor(ColorManager.shared.secondaryText.opacity(0.7))
                            }
                            .padding(.top, 40)
                            .padding(.bottom, 20)
                        }
                    }
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
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(FontManager.playfairRegular(size: 16))
                    .foregroundColor(ColorManager.shared.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(ColorManager.shared.secondaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}

#Preview {
    SettingsView()
}
