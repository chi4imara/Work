import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    let settingsItems: [SettingsItem] = [
        SettingsItem(title: "Terms of Use", icon: "doc.text.fill", color: ColorManager.primaryBlue, action: .url("https://www.privacypolicies.com/live/3718e941-bb41-4687-a9e4-b31bfc0c3397")),
        SettingsItem(title: "Privacy Policy", icon: "lock.shield.fill", color: ColorManager.accentColor, action: .url("https://www.privacypolicies.com/live/71d4b236-0a6b-49ff-937d-8925e53ffb42")),
        SettingsItem(title: "Contact Us", icon: "envelope.fill", color: ColorManager.primaryYellow, action: .url("https://www.privacypolicies.com/live/71d4b236-0a6b-49ff-937d-8925e53ffb42")),
        SettingsItem(title: "Rate App", icon: "star.fill", color: ColorManager.warningColor, action: .rate)
    ]
    
    var body: some View {
            ZStack {
                ColorManager.mainGradient
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Settings")
                            .font(FontManager.ubuntu(size: 28, weight: .bold))
                            .foregroundColor(ColorManager.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            VStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(ColorManager.primaryBlue.opacity(0.1))
                                        .frame(width: 100, height: 100)
                                    
                                    Image(systemName: "gamecontroller.fill")
                                        .font(.system(size: 50, weight: .light))
                                        .foregroundColor(ColorManager.primaryBlue)
                                }
                                .padding(.top, 40)
                                
                                Text("GameBoxed")
                                    .font(FontManager.ubuntu(size: 28, weight: .bold))
                                    .foregroundColor(ColorManager.primaryText)
                            }
                            .padding(.bottom, 20)
                            
                            VStack(spacing: 16) {
                                ForEach(settingsItems) { item in
                                    SettingsRowView(item: item) {
                                        handleAction(item.action)
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 50)
                        }
                    }
                }
            }
    }
    
    private func handleAction(_ action: SettingsAction) {
        switch action {
        case .url(let urlString):
            openURL(urlString)
        case .rate:
            requestReview()
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestReview() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

struct SettingsItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let action: SettingsAction
}

enum SettingsAction {
    case url(String)
    case rate
}

struct SettingsRowView: View {
    let item: SettingsItem
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(item.color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(item.color)
                }
                
                Text(item.title)
                    .font(FontManager.ubuntu(size: 16, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ColorManager.secondaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorManager.cardBackground)
                    .shadow(color: ColorManager.shadowColor, radius: 4, x: 0, y: 2)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}
