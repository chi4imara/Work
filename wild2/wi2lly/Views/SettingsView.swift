import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 0) {
                    headerView
                    
                    settingsContent
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Settings")
                    .font(.playfair(28, weight: .bold))
                    .foregroundColor(Color.theme.primaryBlue)
                
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var settingsContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                appInfoSection
                
                legalSection
                
                supportSection
                
                rateAppSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 10)
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [Color.theme.primaryBlue, Color.theme.primaryYellow],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "book.fill")
                            .font(.system(size: 40, weight: .medium))
                            .foregroundColor(.white)
                    )
                
                VStack(spacing: 4) {
                    Text("Word Collection")
                        .font(.playfair(20, weight: .bold))
                        .foregroundColor(Color.theme.primaryBlue)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.theme.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private var legalSection: some View {
        VStack(spacing: 0) {
            SettingsRow(
                icon: "doc.text",
                title: "Terms of Use",
                iconColor: Color.theme.primaryBlue
            ) {
                openURL("https://www.termsfeed.com/live/dde50325-96b4-4988-8c64-ccf619280b13")
            }
            
            Divider()
                .padding(.leading, 50)
            
            SettingsRow(
                icon: "hand.raised",
                title: "Privacy Policy",
                iconColor: Color.theme.accentGreen
            ) {
                openURL("https://www.termsfeed.com/live/6989f25f-33b7-4851-a87d-37f697d0fbe9")
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.theme.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private var supportSection: some View {
        VStack(spacing: 0) {
            SettingsRow(
                icon: "envelope",
                title: "Contact Us",
                iconColor: Color.theme.accentPurple
            ) {
                openURL("https://www.termsfeed.com/live/6989f25f-33b7-4851-a87d-37f697d0fbe9")
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.theme.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private var rateAppSection: some View {
        VStack(spacing: 0) {
            SettingsRow(
                icon: "star",
                title: "Rate the App",
                iconColor: Color.theme.primaryYellow
            ) {
                requestReview()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.theme.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
        )
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

struct SettingsRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.playfair(16, weight: .medium))
                    .foregroundColor(Color.theme.primaryBlue)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.theme.textGray)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    SettingsView()
}
