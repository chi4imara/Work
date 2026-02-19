import SwiftUI
import StoreKit

struct SettingsView: View {
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(FontManager.bold(size: 28))
                        .foregroundColor(ColorManager.primaryBlue)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 0) {
                        SettingsSection {
                            VStack(spacing: 20) {
                                VStack(spacing: 12) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 60, weight: .light))
                                        .foregroundColor(ColorManager.primaryYellow)
                                        .shadow(color: ColorManager.primaryYellow.opacity(0.3), radius: 10, x: 0, y: 5)
                                    
                                    Text("Beauty Inventory")
                                        .font(FontManager.bold(size: 24))
                                        .foregroundColor(ColorManager.primaryBlue)
                                }
                            }
                        }
                        
                        SettingsSection {
                            VStack(spacing: 0) {
                                SettingsRow(
                                    icon: "doc.text.fill",
                                    title: "Terms & Conditions",
                                    action: {
                                        openURL("https://www.freeprivacypolicy.com/live/91e61c63-ed64-4977-8744-653bd65deed5")
                                    }
                                )
                                
                                Divider()
                                    .padding(.leading, 50)
                                
                                SettingsRow(
                                    icon: "hand.raised.fill",
                                    title: "Privacy Policy",
                                    action: {
                                        openURL("https://www.freeprivacypolicy.com/live/e8c58434-cfc8-4612-bfec-769577a33133")
                                    }
                                )
                            }
                        }
                        
                        SettingsSection {
                            VStack(spacing: 0) {
                                SettingsRow(
                                    icon: "envelope.fill",
                                    title: "Contact Us",
                                    action: {
                                        openURL("https://forms.gle/fg3A1WhH59Tc5wMt9")
                                    }
                                )
                                
                                Divider()
                                    .padding(.leading, 50)
                                
                                SettingsRow(
                                    icon: "star.fill",
                                    title: "Rate App",
                                    action: {
                                        requestReview()
                                    }
                                )
                            }
                        }
                        
                        VStack(spacing: 8) {
                            Text("Made with ❤️ for beauty enthusiasts")
                                .font(FontManager.regular(size: 14))
                                .foregroundColor(ColorManager.darkGray.opacity(0.7))
                                .multilineTextAlignment(.center)
                            
                            Text("Keep your beauty collection organized")
                                .font(FontManager.light(size: 12))
                                .foregroundColor(ColorManager.darkGray.opacity(0.5))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 40)
                        .padding(.bottom, 20)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 10)
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

struct SettingsSection<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.6))
        .cornerRadius(16)
        .padding(.bottom, 16)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(ColorManager.primaryBlue)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(FontManager.medium(size: 16))
                    .foregroundColor(ColorManager.primaryBlue)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(ColorManager.darkGray.opacity(0.6))
            }
            .padding(.vertical, 12)
        }
    }
}
