import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.playfair(32, weight: .bold))
                        .foregroundColor(Color.black)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 30) {
                        headerSection
                        
                        settingsSection
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 50)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                ColorTheme.primaryPink.opacity(0.3),
                                ColorTheme.accentPurple.opacity(0.3)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 50))
                    .foregroundColor(ColorTheme.primaryPink)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var settingsSection: some View {
        VStack(spacing: 16) {
            SettingsRow(
                icon: "lock.fill",
                title: "Data Protection Policy",
                iconColor: ColorTheme.accentPurple,
                action: openDataProtection
            )
            
            SettingsRow(
                icon: "envelope.fill",
                title: "Contact Email",
                iconColor: ColorTheme.accentGreen,
                action: openEmail
            )
            
            SettingsRow(
                icon: "star.fill",
                title: "Rate App",
                iconColor: ColorTheme.primaryYellow,
                action: rateApp
            )
        }
        .padding(.horizontal, 20)
    }
    
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://www.termsfeed.com/live/67ef23d7-bb96-4bc6-aecc-2eed0a07029f") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openEmail() {
        if let url = URL(string: "https://www.termsfeed.com/live/67ef23d7-bb96-4bc6-aecc-2eed0a07029f") {
            UIApplication.shared.open(url)
        }
    }
    
    private func rateApp() {
        requestReview()
    }
    
    private func openDataProtection() {
        if let url = URL(string: "https://www.termsfeed.com/live/67ef23d7-bb96-4bc6-aecc-2eed0a07029f") {
            UIApplication.shared.open(url)
        }
    }
    
    private func leaveReview() {
        if let url = URL(string: "https://google.com") {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.playfair(18, weight: .medium))
                    .foregroundColor(ColorTheme.textSecondary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(ColorTheme.textTertiary)
            }
            .padding(16)
            .background(ColorTheme.cardBackground)
            .cornerRadius(16)
            .shadow(
                color: Color.black.opacity(isPressed ? 0.15 : 0.08),
                radius: isPressed ? 6 : 4,
                x: 0,
                y: isPressed ? 3 : 2
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
    }
}

#Preview {
    SettingsView()
}
