import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    private let settingsItems = [
        SettingsItem(title: "Privacy Policy", icon: "hand.raised.fill", action: .privacyPolicy, color: ColorTheme.primaryBlue),
        SettingsItem(title: "Contact Us", icon: "envelope.fill", action: .contact, color: ColorTheme.primaryYellow),
        SettingsItem(title: "Rate App", icon: "star.fill", action: .rate, color: ColorTheme.accentGreen)
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 0) {
                    headerView
                    
                    VStack(spacing: 24) {
                        ForEach(Array(settingsItems.enumerated()), id: \.offset) { index, item in
                            SettingsItemView(item: item, index: index)
                        }
                    }
                    .padding(.top, 30)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .alert("Rate Our App", isPresented: $showingRateAlert) {
            Button("Not Now", role: .cancel) { }
            Button("Rate") {
                requestAppStoreReview()
            }
        } message: {
            Text("If you enjoy using this app, please take a moment to rate it. Thanks for your support!")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private func requestAppStoreReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsItemView: View {
    let item: SettingsItem
    let index: Int
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            HapticManager.impact(.light)
            handleAction(item.action)
        }) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [item.color, item.color.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 70)
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                Text(item.title)
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(item.color)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(ColorTheme.cardGradient)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(
                color: item.color.opacity(0.2),
                radius: isPressed ? 4 : 10,
                x: 0,
                y: isPressed ? 2 : 5
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
    
    private func handleAction(_ action: SettingsAction) {
        switch action {
        case .privacyPolicy:
            openURL("https://www.termsfeed.com/live/62c0b7f6-e36e-4147-b98d-a15f6b978a85")
        case .contact:
            openURL("https://www.termsfeed.com/live/62c0b7f6-e36e-4147-b98d-a15f6b978a85")
        case .rate:
            showRateAlert()
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func showRateAlert() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController {
            
            let alert = UIAlertController(
                title: "Rate Our App",
                message: "If you enjoy using this app, please take a moment to rate it. Thanks for your support!",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Not Now", style: .cancel))
            alert.addAction(UIAlertAction(title: "Rate", style: .default) { _ in
                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            })
            
            rootViewController.present(alert, animated: true)
        }
    }
}

struct SettingsItem {
    let title: String
    let icon: String
    let action: SettingsAction
    let color: Color
}

enum SettingsAction {
    case privacyPolicy
    case contact
    case rate
}

#Preview {
    SettingsView()
}
