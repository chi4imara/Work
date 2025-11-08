import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        AppColors.backgroundGradientStart,
                        AppColors.backgroundGradientEnd
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        
                        VStack(spacing: 20) {
                            SettingsSection(title: "Legal") {
                                VStack(spacing: 12) {
                                    SettingsRow(
                                        icon: "doc.text",
                                        title: "Terms and Conditions",
                                        action: { openURL("https://docs.google.com/document/d/1bCj81ESadA_7st8Afh7ltCygx59ZOVp_JprpQuax-XQ/edit?usp=sharing") }
                                    )
                                    
                                    SettingsRow(
                                        icon: "hand.raised",
                                        title: "Privacy Policy",
                                        action: { openURL("https://docs.google.com/document/d/1qLzljOl54ARMGUTIoC0ZzuYe9N8uClDK2OIsr5ShOZ8/edit?usp=sharing") }
                                    )
                                }
                            }
                            
                            SettingsSection(title: "Support") {
                                VStack(spacing: 12) {
                                    SettingsRow(
                                        icon: "questionmark.circle",
                                        title: "Contact Us",
                                        action: { openURL("https://forms.gle/9bMPKJXsH1A2RcnJA") }
                                    )
                                }
                            }
                            
                            SettingsSection(title: "App") {
                                VStack(spacing: 12) {
                                    SettingsRow(
                                        icon: "star",
                                        title: "Rate App",
                                        action: { requestReview() }
                                    )
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            AppColors.primaryBlue,
                            AppColors.accentPurple
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 40, weight: .medium))
                        .foregroundColor(.white)
                )
                .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 4) {
                Text("Pet Care")
                    .font(FontManager.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.primaryText)
            }
        }
        .padding(.bottom, 20)
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
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 4)
            
            VStack(spacing: 1) {
                content
            }
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.primaryBlue.opacity(0.1), lineWidth: 1)
            )
        }
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
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.primaryBlue)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.clear)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
