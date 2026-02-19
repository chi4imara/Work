import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var appState: AppState
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            ColorManager.mainGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(FontManager.ubuntu(28, weight: .bold))
                        .foregroundColor(ColorManager.textWhite)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            SettingsCard(
                                title: "Privacy Policy",
                                icon: "shield.checkerboard",
                                action: {
                                    openURL("https://www.termsfeed.com/live/e79d1a8b-8ee7-47fc-a3b3-06f9163a2485")
                                }
                            )
                            
                            SettingsCard(
                                title: "Contact Us",
                                icon: "envelope",
                                action: {
                                    openURL("https://www.termsfeed.com/live/e79d1a8b-8ee7-47fc-a3b3-06f9163a2485")
                                }
                            )
                            
                            SettingsCard(
                                title: "Rate App",
                                icon: "star",
                                action: {
                                    requestAppReview()
                                }
                            )
                        }
                        .padding(.top, 30)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsCard: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(ColorManager.accentYellow.opacity(0.2))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(ColorManager.accentYellow)
                }
                
                Text(title)
                    .font(FontManager.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorManager.textWhite)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ColorManager.textSecondary)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorManager.cardGradient)
            )
        }
    }
}


#Preview {
    SettingsView(appState: AppState())
}
