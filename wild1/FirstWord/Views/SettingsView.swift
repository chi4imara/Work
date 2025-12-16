import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    private let settingsItems = [
        SettingListItem(title: "Terms of Use", icon: "doc.text.fill", color: Color.theme.primaryBlue),
        SettingListItem(title: "Privacy Policy", icon: "lock.shield.fill", color: Color.theme.categoryPersonal),
        SettingListItem(title: "Rate App", icon: "star.fill", color: Color.theme.buttonPrimary, isPrimary: true),
        SettingListItem(title: "Contact Us", icon: "envelope.fill", color: Color.theme.categoryWork)
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(Color.theme.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(Array(settingsItems.enumerated()), id: \.offset) { index, item in
                            SettingListRow(item: item) {
                                if item.isPrimary {
                                    requestReview()
                                } else {
                                    if item.title == "Terms of Use" {
                                        openURL("https://www.privacypolicies.com/live/e892df40-33e5-4b90-bd23-ec56471a6939")
                                    } else if item.title == "Privacy Policy" {
                                        openURL("https://www.privacypolicies.com/live/3d7ff378-f145-4f4d-bc45-290bea1c5ac9")
                                    } else {
                                        openURL("https://www.privacypolicies.com/live/3d7ff378-f145-4f4d-bc45-290bea1c5ac9")
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
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

struct SettingListItem {
    let title: String
    let icon: String
    let color: Color
    var isPrimary: Bool = false
}

struct SettingListRow: View {
    let item: SettingListItem
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: item.isPrimary ? [
                                    item.color,
                                    item.color.opacity(0.8)
                                ] : [
                                    item.color.opacity(0.2),
                                    item.color.opacity(0.15)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    item.isPrimary ? Color.white.opacity(0.3) : item.color.opacity(0.4),
                                    lineWidth: 1.5
                                )
                        )
                        .shadow(
                            color: item.color.opacity(item.isPrimary ? 0.5 : 0.2),
                            radius: item.isPrimary ? 12 : 6,
                            x: 0,
                            y: item.isPrimary ? 6 : 3
                        )
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(item.isPrimary ? .white : item.color)
                }
                
                Text(item.title)
                    .font(.ubuntu(18, weight: item.isPrimary ? .bold : .medium))
                    .foregroundColor(Color.theme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.theme.textSecondary)
                    .opacity(0.6)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.theme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        item.color.opacity(0.3),
                                        item.color.opacity(0.1)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .opacity(isPressed ? 0.9 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}
