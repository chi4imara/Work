import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 16) {
                        SettingsRow(
                            icon: "star.fill",
                            title: "Rate App",
                            subtitle: "Share your feedback",
                            iconColor: ColorTheme.accent,
                            iconBackground: ColorTheme.accent.opacity(0.2)
                        ) {
                            requestReview()
                        }
                        
                        SettingsRow(
                            icon: "doc.text",
                            title: "Terms of Use",
                            subtitle: "Read our terms and conditions",
                            iconColor: ColorTheme.lightBlue,
                            iconBackground: ColorTheme.lightBlue.opacity(0.2)
                        ) {
                            openURL("https://www.freeprivacypolicy.com/live/308cc24a-8aa1-4df8-94c1-01ee641b5824")
                        }
                        
                        SettingsRow(
                            icon: "shield.fill",
                            title: "Privacy Policy",
                            subtitle: "How we protect your data",
                            iconColor: ColorTheme.secondary,
                            iconBackground: ColorTheme.secondary.opacity(0.2)
                        ) {
                            openURL("https://www.freeprivacypolicy.com/live/eea6680d-63d3-4f31-b8c4-edf77a0d5004")
                        }
                        
                        SettingsRow(
                            icon: "envelope.fill",
                            title: "Contact Us",
                            subtitle: "Get in touch with us",
                            iconColor: ColorTheme.accent,
                            iconBackground: ColorTheme.accent.opacity(0.2)
                        ) {
                            openURL("https://forms.gle/zRMqeck4uTaf27Px6")
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(ColorTheme.white)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconColor: Color
    let iconBackground: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconBackground)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(ColorTheme.white)
                    
                    Text(subtitle)
                        .font(.ubuntu(13))
                        .foregroundColor(ColorTheme.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorTheme.textSecondary)
            }
            .padding(16)
            .background(ColorTheme.cardGradient)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .opacity(isPressed ? 0.9 : 1.0)
        }
    }
}

#Preview {
    SettingsView()
}

