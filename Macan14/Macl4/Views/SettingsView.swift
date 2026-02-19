import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 0) {
                    Text("Settings")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(.appText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                    
                    VStack(spacing: 0) {
                        SettingsSectionView(title: "Legal") {
                            SettingsRowView(
                                title: "Terms and Conditions",
                                icon: "doc.text.fill",
                                iconColor: .appPrimary
                            ) {
                                openURL("https://www.privacypolicies.com/live/ce6734c7-bead-4a4a-846e-43bb8d3ec734")
                            }
                            
                            SettingsRowView(
                                title: "Privacy Policy",
                                icon: "lock.shield.fill",
                                iconColor: .appSuccess
                            ) {
                                openURL("https://www.privacypolicies.com/live/4b6e8b4e-5fe8-4b4d-ad3f-fbcae2f6f19b")
                            }
                        }
                        
                        SettingsSectionView(title: "Support") {
                            SettingsRowView(
                                title: "Contact Us",
                                icon: "envelope.fill",
                                iconColor: .appPrimary
                            ) {
                                openURL("https://www.privacypolicies.com/live/4b6e8b4e-5fe8-4b4d-ad3f-fbcae2f6f19b")
                            }
                        }
                        
                        SettingsSectionView(title: "App") {
                            SettingsRowView(
                                title: "Rate App",
                                icon: "star.fill",
                                iconColor: .appAccent
                            ) {
                                showingRateAlert = true
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .alert("Rate App", isPresented: $showingRateAlert) {
            Button("Rate Now") {
                requestReview()
            }
            Button("Later", role: .cancel) { }
        } message: {
            Text("Enjoying the app? Please take a moment to rate us in the App Store!")
        }
    }
    
    private func requestReview() {
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

struct SettingsSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title.uppercased())
                .font(.ubuntu(12, weight: .medium))
                .foregroundColor(.appTextSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color.appCardBackground)
            .cornerRadius(12)
            .shadow(color: Color.appShadow, radius: 8, x: 0, y: 4)
        }
        .padding(.bottom, 24)
    }
}

struct SettingsRowView: View {
    let title: String
    let icon: String
    let iconColor: Color
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.appText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.appTextSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(isPressed ? Color.gray.opacity(0.1) : Color.clear)
            .contentShape(Rectangle())
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    SettingsView()
}
