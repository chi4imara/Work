import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.playfairDisplay(32, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(spacing: 24) {
                        AppInfoSection()
                        
                        SettingsSection(title: "Support") {
                            SettingsRow(
                                icon: "envelope.fill",
                                iconColor: ColorTheme.lightBlue,
                                title: "Contact Email",
                                subtitle: "Get in touch with us",
                                action: {
                                    openURL("https://www.privacypolicies.com/live/ee35fac1-d66f-42af-b7ee-e6de809d436c")
                                }
                            )
                            
                            Divider()
                                .overlay {
                                    Color.white
                                }
                                .padding(.horizontal, -20)
                                .frame(maxWidth: .infinity)
                            
                            SettingsRow(
                                icon: "star.fill",
                                iconColor: ColorTheme.orange,
                                title: "Rate the App",
                                subtitle: "Share your feedback",
                                action: {
                                    requestAppReview()
                                }
                            )
                        }
                        
                        SettingsSection(title: "Legal") {
                            SettingsRow(
                                icon: "shield.fill",
                                iconColor: ColorTheme.green,
                                title: "Privacy Policy",
                                subtitle: "How we protect your data",
                                action: {
                                    openURL("https://www.privacypolicies.com/live/ee35fac1-d66f-42af-b7ee-e6de809d436c")
                                }
                            )
                        }
                        
                        AppVersionView()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct AppInfoSection: View {
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                ColorTheme.lightBlue,
                                ColorTheme.orange
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "drop.circle.fill")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
            }
            
            VStack(spacing: 8) {
                Text("Grooming Essentials")
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Organize your grooming products")
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, 20)
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
                .padding(.horizontal, 4)
            
            VStack(spacing: 1) {
                content
            }
            .cardStyle()
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text(subtitle)
                        .font(.playfairDisplay(14, weight: .regular))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorTheme.tertiaryText)
            }
            .padding(16)
            .background(ColorTheme.tertiaryBackground.opacity(0.1))
        }
    }
}

struct AppVersionView: View {
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Made with ❤️ for grooming enthusiasts")
                .font(.playfairDisplay(12, weight: .regular))
                .foregroundColor(ColorTheme.tertiaryText.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
}

struct CreativeSettingsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            
                            CreativeSettingsCard(
                                icon: "envelope.circle.fill",
                                title: "Contact",
                                subtitle: "Get Support",
                                color: ColorTheme.lightBlue,
                                action: { openURL("https://google.com") }
                            )
                            
                            CreativeSettingsCard(
                                icon: "star.circle.fill",
                                title: "Rate App",
                                subtitle: "Love it?",
                                color: ColorTheme.orange,
                                action: { requestAppReview() }
                            )
                            
                            CreativeSettingsCard(
                                icon: "shield.circle.fill",
                                title: "Privacy",
                                subtitle: "Your Data",
                                color: ColorTheme.green,
                                action: { openURL("https://google.com") }
                            )
                            
                            CreativeSettingsCard(
                                icon: "info.circle.fill",
                                title: "About",
                                subtitle: "Learn More",
                                color: ColorTheme.yellow,
                                action: { }
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct CreativeSettingsCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(color)
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text(subtitle)
                        .font(.playfairDisplay(12, weight: .regular))
                        .foregroundColor(ColorTheme.secondaryText)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        color.opacity(0.1),
                        color.opacity(0.05)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: color.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}

#Preview("Creative Layout") {
    CreativeSettingsView()
}
