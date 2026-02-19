import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    headerView
                    
                    settingsGrid
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 100, height: 100)
                    .shadow(color: AppColors.shadowColor, radius: 15, x: 0, y: 8)
                
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 40, weight: .light))
                    .foregroundColor(AppColors.lightBlue)
            }
            
            Text("Settings")
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
        }
    }
    
    private var settingsGrid: some View {
        VStack(spacing: 20) {
            HStack(spacing: 15) {
                SettingsCard(
                    title: "Privacy Policy",
                    subtitle: "Data Protection",
                    icon: "shield.fill",
                    color: AppColors.lightBlue,
                    size: .medium
                ) {
                    openURL("https://www.privacypolicies.com/live/42929a84-292c-4241-bcdc-8a05f09fa45e")
                }
                
                SettingsCard(
                    title: "Rate App",
                    subtitle: "Leave Review",
                    icon: "star.fill",
                    color: AppColors.orange,
                    size: .medium
                ) {
                    requestReview()
                }
            }
            
            SettingsCard(
                title: "Contact Us",
                subtitle: "Get in touch for support or feedback",
                icon: "envelope.fill",
                color: AppColors.workingStatus,
                size: .large
            ) {
                openURL("https://www.privacypolicies.com/live/42929a84-292c-4241-bcdc-8a05f09fa45e")
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func shareApp() {
        let activityVC = UIActivityViewController(
            activityItems: ["Check out this amazing inventory app!"],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
}

struct SettingsCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let size: CardSize
    let action: () -> Void
    
    enum CardSize {
        case small, medium, large
        
        var height: CGFloat {
            switch self {
            case .small: return 80
            case .medium: return 120
            case .large: return 100
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .small: return 20
            case .medium: return 28
            case .large: return 32
            }
        }
        
        var titleSize: CGFloat {
            switch self {
            case .small: return 14
            case .medium: return 16
            case .large: return 18
            }
        }
        
        var subtitleSize: CGFloat {
            switch self {
            case .small: return 12
            case .medium: return 14
            case .large: return 16
            }
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: size == .large ? 12 : 8) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(color.opacity(0.2))
                            .frame(width: size.iconSize + 16, height: size.iconSize + 16)
                        
                        Image(systemName: icon)
                            .font(.system(size: size.iconSize, weight: .medium))
                            .foregroundColor(color)
                    }
                    
                    if size == .large {
                        Spacer()
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.playfairDisplay(size.titleSize, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(1)
                    
                    Text(subtitle)
                        .font(.playfairDisplay(size.subtitleSize, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(size == .large ? 2 : 1)
                }
                
                if size != .large {
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: size.height)
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(20)
            .shadow(color: AppColors.shadowColor, radius: 10, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(color.opacity(0.3), lineWidth: 1)
            )
        }
        .scaleEffect(1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: false)
    }
}

struct SettingsButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    SettingsView()
}
