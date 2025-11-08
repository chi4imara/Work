import SwiftUI
import StoreKit

struct CreativeSettingsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.universalGradient
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        headerSection
                        
                        creativeGridLayout
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Text("Settings")
                .font(.appLargeTitle)
                .foregroundColor(.appPrimary)
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [AppColors.primary, AppColors.accent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: "leaf.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }
        }
        .padding(.top, 20)
    }
    
    private var creativeGridLayout: some View {
        VStack {
            HStack(spacing: 16) {
                CreativeSettingsCard(
                    icon: "star.fill",
                    iconColor: .appWarning,
                    title: "Rate App",
                    subtitle: "Love the app? Rate us!",
                    style: .large
                ) {
                    requestAppReview()
                }
                
                CreativeSettingsCard(
                    icon: "doc.text.fill",
                    iconColor: .appPrimary,
                    title: "Terms",
                    subtitle: "User agreement",
                    style: .medium
                ) {
                    openURL("https://google.com")
                }
            }
            .padding(.bottom, 8)
            
            HStack(spacing: 16) {
                CreativeSettingsCard(
                    icon: "hand.raised.fill",
                    iconColor: .appAccent,
                    title: "Privacy",
                    subtitle: "Data protection",
                    style: .medium
                ) {
                    openURL("https://google.com")
                }
                
                CreativeSettingsCard(
                    icon: "envelope.fill",
                    iconColor: .blue,
                    title: "Contact Us",
                    subtitle: "Get help and support",
                    style: .large
                ) {
                    openURL("https://google.com")
                }
            }
        }
    }
}

private func requestAppReview() {
    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
        SKStoreReviewController.requestReview(in: scene)
    }
}

private func openURL(_ urlString: String) {
    if let url = URL(string: urlString) {
        UIApplication.shared.open(url)
    }
}

struct CreativeSettingsCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let style: CardStyle
    let action: () -> Void
    
    enum CardStyle {
        case medium, large
        
        var height: CGFloat {
            switch self {
            case .medium: return 140
            case .large: return 140
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .medium: return 24
            case .large: return 32
            }
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: style.iconSize, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.appHeadline)
                        .foregroundColor(.appPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(.appCaption1)
                        .foregroundColor(.appMediumGray)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                
                Spacer()
            }
            .frame(height: style.height)
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

typealias SettingsView = CreativeSettingsView

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
