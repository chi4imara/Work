import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var viewModel: GroomingViewModel
    @State private var showRateAlert = false
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(FontManager.playfairDisplay(.bold, size: 28))
                        .foregroundColor(.primaryWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        SettingsSection(title: "App") {
                            SettingsRow(
                                icon: "star.fill",
                                title: "Rate App",
                                subtitle: "Help us improve",
                                iconColor: .primaryOrange
                            ) {
                                requestReview()
                            }
                        }
                        
                        SettingsSection(title: "Support") {
                            SettingsRow(
                                icon: "envelope.fill",
                                title: "Contact Us",
                                subtitle: "Get in touch",
                                iconColor: .lightBlue
                            ) {
                                openURL("https://www.privacypolicies.com/live/b257c4b9-44b1-477d-ae1f-8382e5232fa7")
                            }
                        }
                        
                        SettingsSection(title: "Legal") {
                            SettingsRow(
                                icon: "shield.fill",
                                title: "Privacy Policy",
                                subtitle: "How we protect your data",
                                iconColor: .successGreen
                            ) {
                                openURL("https://www.privacypolicies.com/live/b257c4b9-44b1-477d-ae1f-8382e5232fa7")
                            }
                        }
                        
                        AppInfoSection()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
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
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(FontManager.playfairDisplay(.semibold, size: 18))
                .foregroundColor(.primaryWhite.opacity(0.8))
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardGradient)
            )
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
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(FontManager.playfairDisplay(.medium, size: 16))
                        .foregroundColor(.primaryWhite)
                    
                    Text(subtitle)
                        .font(FontManager.playfairDisplay(.regular, size: 14))
                        .foregroundColor(.primaryWhite.opacity(0.6))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primaryWhite.opacity(0.4))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

struct AppInfoSection: View {
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.cardGradient)
                    .frame(width: 80, height: 80)
                
                Image(systemName: "scissors")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(.primaryOrange)
            }
            
            VStack(spacing: 8) {
                Text("Grooming Pro")
                    .font(FontManager.playfairDisplay(.semibold, size: 20))
                    .foregroundColor(.primaryWhite)
                
                Text("Your personal grooming companion")
                    .font(FontManager.playfairDisplay(.regular, size: 14))
                    .foregroundColor(.primaryWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 20)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(GroomingViewModel())
    }
}
