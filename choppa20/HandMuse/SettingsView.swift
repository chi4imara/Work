import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    var body: some View {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        VStack(spacing: 16) {
                            Image(systemName: "gear")
                                .font(.system(size: 50))
                                .foregroundColor(Color.theme.primaryPurple)
                            
                            Text("Settings")
                                .font(.playfairDisplay(32, weight: .bold))
                                .foregroundColor(Color.theme.primaryText)
                        }
                        .padding(.top, 20)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 20) {
                            
                            SettingsCardView(
                                icon: "doc.text",
                                title: "Terms of Use",
                                subtitle: "Legal agreement",
                                color: Color.theme.primaryBlue
                            ) {
                                openURL("https://www.privacypolicies.com/live/79be23b6-cd08-4287-83b6-259182122273")
                            }
                            
                            SettingsCardView(
                                icon: "lock.shield",
                                title: "Privacy Policy",
                                subtitle: "Data protection",
                                color: Color.theme.primaryPurple
                            ) {
                                openURL("https://www.privacypolicies.com/live/facc08d5-8fcf-41bb-afa1-1b6d2f6f4614")
                            }
                            
                            SettingsCardView(
                                icon: "envelope",
                                title: "Contact Us",
                                subtitle: "Get in touch",
                                color: Color.theme.primaryYellow
                            ) {
                                openURL("https://www.privacypolicies.com/live/facc08d5-8fcf-41bb-afa1-1b6d2f6f4614")
                            }
                            
                            SettingsCardView(
                                icon: "star.fill",
                                title: "Rate App",
                                subtitle: "Leave a review",
                                color: Color.orange
                            ) {
                                requestReview()
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 120)
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

struct SettingsCardView: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(color.opacity(0.2))
                    )
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.playfairDisplay(16, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(.playfairDisplay(12))
                        .foregroundColor(Color.theme.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, minHeight: 140)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.theme.cardBackground)
                    .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
    }
}

struct CircularSettingsButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(color)
                        .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}
