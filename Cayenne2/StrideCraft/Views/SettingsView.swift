import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    @Environment(\.requestReview) var requestReview

    var body: some View {
        ZStack {
            ColorTheme.primaryBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Text("Settings")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    VStack(spacing: 20) {
                        settingsSection(title: "App") {
                            VStack(spacing: 0) {
                                SettingsRow(
                                    title: "Rate App",
                                    icon: "star.fill",
                                    color: ColorTheme.warning
                                ) {
                                    requestReview()
                                }
                                
                                Divider()
                                    .background(ColorTheme.secondaryText.opacity(0.3))
                                
                                SettingsRow(
                                    title: "Contact Us",
                                    icon: "envelope.fill",
                                    color: ColorTheme.lightBlue
                                ) {
                                    openURL("https://www.termsfeed.com/live/c0b908d1-e9f8-4f26-9bae-dee5a90fa4d7")
                                }
                            }
                        }
                        
                        settingsSection(title: "Legal") {
                            VStack(spacing: 0) {
                                SettingsRow(
                                    title: "Privacy Policy",
                                    icon: "hand.raised.fill",
                                    color: ColorTheme.success
                                ) {
                                    openURL("https://www.termsfeed.com/live/c0b908d1-e9f8-4f26-9bae-dee5a90fa4d7")
                                }
                            }
                        }
                        
                        settingsSection(title: "About") {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "shoe.2.fill")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(ColorTheme.lightBlue)
                                        .frame(width: 30)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("StrideCraft")
                                            .font(.ubuntu(16, weight: .bold))
                                            .foregroundColor(ColorTheme.primaryText)
                                    }
                                    
                                    Spacer()
                                }
                                
                                Text("Keep your shoe collection organized and track every pair you own.")
                                    .font(.ubuntu(14, weight: .regular))
                                    .foregroundColor(ColorTheme.secondaryText)
                                    .lineSpacing(2)
                            }
                            .padding(16)
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.bottom, 20)
            }
        }
    }
    
    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                content()
            }
            .background(ColorTheme.cardBackground)
            .cornerRadius(12)
            .padding(.horizontal, 20)
        }
    }
    
    private func requestAppRating() {
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

struct SettingsRow: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: 30)
                
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

#Preview {
    SettingsView()
}
