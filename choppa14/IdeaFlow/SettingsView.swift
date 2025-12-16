import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.playfairDisplay(32, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerSection
                        
                        VStack(spacing: 16) {
                            legalSection
                            
                            supportSection
                            
                            appSection
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.purpleGradient)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "lightbulb.max")
                        .font(.system(size: 40, weight: .light))
                        .foregroundColor(.white)
                )
            
            VStack(spacing: 4) {
                Text("IdeaFlow")
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                
                Text("Content Ideas Manager")
                    .font(.playfairDisplay(14, weight: .regular))
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
        .padding(.vertical, 20)
    }
    
    private var legalSection: some View {
        SettingsSection(title: "Legal") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "doc.text",
                    title: "Terms of Use",
                    iconColor: Color.theme.primaryBlue
                ) {
                    openURL("https://doc-hosting.flycricket.io/postory-ideaflow-terms-of-use/a218f712-68ab-4b8d-ad60-53812fc57708/terms")
                }
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsRow(
                    icon: "hand.raised",
                    title: "Privacy Policy",
                    iconColor: Color.theme.primaryPurple
                ) {
                    openURL("https://doc-hosting.flycricket.io/postory-ideaflow-privacy-policy/2eb3c0da-1500-44c1-9f2b-641515c09012/privacy")
                }
            }
        }
    }
    
    private var supportSection: some View {
        SettingsSection(title: "Support") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "envelope",
                    title: "Contact Us",
                    iconColor: Color.theme.primaryYellow
                ) {
                    openURL("https://forms.gle/PPxhgVqhBnmABYdRA")
                }
            }
        }
    }
    
    private var appSection: some View {
        SettingsSection(title: "App") {
            VStack(spacing: 0) {
                SettingsRow(
                    icon: "star.fill",
                    title: "Rate App",
                    iconColor: Color.theme.primaryYellow
                ) {
                    requestReview()
                }
            }
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
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(Color.theme.primaryText)
                .padding(.horizontal, 20)
            
            content
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.theme.cardGradient)
                        .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
                )
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
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(iconColor)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    SettingsView()
}
