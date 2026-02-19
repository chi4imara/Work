import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var viewModel: ToolViewModel
    @State private var showingLoadSampleAlert = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        appSection
                        
                        dataSection
                        
                        legalSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .alert(isPresented: $showingLoadSampleAlert) {
            loadSampleDataAlert
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(FontManager.title(.bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var appSection: some View {
        SettingsSection(title: "App") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "star.fill",
                    title: "Rate App",
                    subtitle: "Help us improve by rating the app"
                ) {
                    requestAppReview()
                }
                
                Divider()
                    .background(ColorTheme.borderColor)
                    .padding(.leading, 50)
                
                SettingsRow(
                    icon: "envelope.fill",
                    title: "Contact Us",
                    subtitle: "Get in touch with our team"
                ) {
                    openURL("https://forms.gle/qs9idZMFyQwmcvef7")
                }
            }
        }
    }
    
    private var dataSection: some View {
        SettingsSection(title: "Data") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "plus.circle.fill",
                    title: "Load Sample Data",
                    subtitle: "Add example tools to get started"
                ) {
                    showingLoadSampleAlert = true
                }
                
                Divider()
                    .background(ColorTheme.borderColor)
                    .padding(.leading, 50)
                
                SettingsRow(
                    icon: "info.circle.fill",
                    title: "Tools Count",
                    subtitle: "\(viewModel.tools.count) tools in catalog",
                    showArrow: false
                ) {
                }
            }
        }
    }
    
    private var supportSection: some View {
        SettingsSection(title: "Support") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "questionmark.circle.fill",
                    title: "Help & FAQ",
                    subtitle: "Find answers to common questions"
                ) {
                    openURL("https://google.com")
                }
                
                Divider()
                    .background(ColorTheme.borderColor)
                    .padding(.leading, 50)
                
                SettingsRow(
                    icon: "bubble.left.fill",
                    title: "Feedback",
                    subtitle: "Share your thoughts and suggestions"
                ) {
                    openEmail()
                }
            }
        }
    }
    
    private var legalSection: some View {
        SettingsSection(title: "Legal") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "doc.text.fill",
                    title: "Privacy Policy",
                    subtitle: "How we handle your data"
                ) {
                    openURL("https://doc-hosting.flycricket.io/toolmark-craft-privacy-policy/0af9a694-7807-4fa6-a4fe-38576236e82d/privacy")
                }
            }
        }
    }
    
    private var loadSampleDataAlert: Alert {
        Alert(
            title: Text("Load Sample Data"),
            message: Text("This will add example tools to your catalog. Your existing tools will not be affected."),
            primaryButton: .default(Text("Load Sample Data")) {
                viewModel.loadSampleData()
            },
            secondaryButton: .cancel()
        )
    }
    
    private func requestAppReview() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
    
    private func openEmail() {
        if let url = URL(string: "mailto:support@example.com") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
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
                .font(FontManager.caption(.medium))
                .foregroundColor(ColorTheme.mutedText)
                .padding(.horizontal, 16)
            
            VStack(spacing: 0) {
                content
            }
            .background(ColorTheme.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(ColorTheme.borderColor, lineWidth: 1)
            )
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let showArrow: Bool
    let action: () -> Void
    
    init(icon: String, title: String, subtitle: String, showArrow: Bool = true, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.showArrow = showArrow
        self.action = action
    }
    
    var body: some View {
        if title == "Tools Count" {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(ColorTheme.accentOrange)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(FontManager.body(.medium))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text(subtitle)
                        .font(FontManager.caption(.regular))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Spacer()
                
                if showArrow {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(ColorTheme.mutedText)
                }
            }
            .padding(16)
        } else {
            Button(action: action) {
                HStack(spacing: 16) {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(ColorTheme.accentOrange)
                        .frame(width: 24, height: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(FontManager.body(.medium))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Text(subtitle)
                            .font(FontManager.caption(.regular))
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                    
                    Spacer()
                    
                    if showArrow {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(ColorTheme.mutedText)
                    }
                }
                .padding(16)
            }
        }
    }
}

#Preview {
    SettingsView(viewModel: ToolViewModel())
}
