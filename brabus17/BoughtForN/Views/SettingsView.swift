import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingPrivacyPolicy = false
    @State private var showingContactEmail = false
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<6, id: \.self) { index in
                Circle()
                    .fill(ColorTheme.white.opacity(0.1))
                    .frame(width: CGFloat.random(in: 8...18))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .animation(
                        Animation.linear(duration: Double.random(in: 5...10))
                            .repeatForever(autoreverses: false),
                        value: UUID()
                    )
            }
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(ColorTheme.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 20) {
                        SettingsButtonView(
                            title: "Contact Email",
                            icon: "envelope.fill",
                            color: ColorTheme.orange
                        ) {
                            if let url = URL(string: "https://forms.gle/L2sHx2qJyRDwDPJMA") {
                                UIApplication.shared.open(url)
                            }
                        }
                        
                        SettingsButtonView(
                            title: "Rate App",
                            icon: "star.fill",
                            color: ColorTheme.purple
                        ) {
                            requestAppReview()
                        }
                        
                        SettingsButtonView(
                            title: "Data Protection",
                            icon: "checkmark.shield.fill",
                            color: ColorTheme.primaryBlue
                        ) {
                            if let url = URL(string: "https://www.freeprivacypolicy.com/live/2f50b67c-cb13-4b10-8520-9248476d38b4") {
                                UIApplication.shared.open(url)
                            }                        }
                    }
                    .padding(.top, 40)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsButtonView: View {
    let title: String
    let icon: String
    let color: Color
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
                    Circle()
                        .fill(color)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(ColorTheme.white)
                }
                
                Text(title)
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorTheme.darkGray)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ColorTheme.darkGray.opacity(0.6))
            }
            .padding(20)
            .background(ColorTheme.cardBackground)
            .cornerRadius(20)
            .shadow(color: ColorTheme.cardShadow, radius: isPressed ? 4 : 12, x: 0, y: isPressed ? 2 : 6)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .rotation3DEffect(
                .degrees(isPressed ? 2 : 0),
                axis: (x: 1, y: 0, z: 0)
            )
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

import WebKit
