import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var viewModel: OutfitViewModel
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    headerView
                    
                    VStack(spacing: 24) {
                        appSection
                        
                        legalSection
                        
                        supportSection
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
            }
        }
        .alert("Rate LookMuse", isPresented: $showingRateAlert) {
            Button("Not Now", role: .cancel) { }
            Button("Rate App") {
                requestAppStoreReview()
            }
        } message: {
            Text("Enjoying LookMuse? Please take a moment to rate us on the App Store!")
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.theme.primaryYellow.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "tshirt.fill")
                    .font(.system(size: 36, weight: .medium))
                    .foregroundColor(Color.theme.primaryYellow)
            }
            
            Text("Settings")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
    
    private var appSection: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "App", icon: "app.badge")
            
            VStack(spacing: 2) {
                SettingsRow(
                    title: "Rate App",
                    icon: "star.fill",
                    iconColor: .orange,
                    action: {
                        showingRateAlert = true
                    }
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.theme.darkCardBackground)
                    .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var legalSection: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "Legal", icon: "doc.text")
            
            VStack(spacing: 2) {
                SettingsRow(
                    title: "Terms of Use",
                    icon: "doc.plaintext",
                    iconColor: .purple,
                    action: {
                        openURL("https://www.privacypolicies.com/live/71bab39e-b3f2-4cf9-a889-1bf44332d669")
                    }
                )
                
                Divider()
                    .background(Color.theme.primaryWhite.opacity(0.2))
                    .padding(.horizontal, 16)
                
                SettingsRow(
                    title: "Privacy Policy",
                    icon: "hand.raised.fill",
                    iconColor: .green,
                    action: {
                        openURL("https://www.privacypolicies.com/live/d500744a-f596-4685-85b5-fbb91763c146")
                    }
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.theme.darkCardBackground)
                    .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var supportSection: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "Support", icon: "questionmark.circle")
            
            VStack(spacing: 2) {
                SettingsRow(
                    title: "Contact Us",
                    icon: "envelope.fill",
                    iconColor: .red,
                    action: {
                        openURL("https://www.privacypolicies.com/live/d500744a-f596-4685-85b5-fbb91763c146")
                    }
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.theme.darkCardBackground)
                    .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private func requestAppStoreReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func shareApp() {
        let activityVC = UIActivityViewController(
            activityItems: ["Check out LookMuse - Your personal style diary!"],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color.theme.primaryYellow)
            
            Text(title)
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(Color.theme.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 4)
        .padding(.bottom, 12)
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.theme.primaryText.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

#Preview {
    SettingsView(viewModel: OutfitViewModel())
}
