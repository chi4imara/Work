import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        SettingsSectionView(title: "Information") {
                            SettingsCardButton(
                                title: "Privacy Policy",
                                icon: "shield.fill",
                                color: ColorManager.accent
                            ) {
                                openURL("https://doc-hosting.flycricket.io/gloww-beauty-mixery-privacy-policy/b13a239f-6db4-4a98-9485-39c38738dcbd/privacy")
                            }
                            
                            SettingsCardButton(
                                title: "Contact Us",
                                icon: "envelope.fill",
                                color: ColorManager.yellow
                            ) {
                                openURL("https://forms.gle/CnL75SNzYamReejH6")
                            }
                        }
                        .padding(.top, 20)
                        
                        SettingsSectionView(title: "App") {
                            SettingsCardButton(
                                title: "Rate App",
                                icon: "star.fill",
                                color: ColorManager.pink
                            ) {
                                requestReview()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
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

struct SettingsSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.ubuntu(20, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
                .padding(.horizontal, 4)
            
            VStack(spacing: 12) {
                content
            }
        }
    }
}

struct SettingsCardButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorManager.cardGradient)
            )
        }
    }
}

#Preview {
    SettingsView()
}
