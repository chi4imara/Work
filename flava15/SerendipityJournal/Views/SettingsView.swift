import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        headerView
                        
                        VStack(spacing: 24) {
                            legalSection
                            
                            supportSection
                            
                            appSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.theme.title1)
                .foregroundColor(Color.theme.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var legalSection: some View {
        SettingsSection(title: "Legal") {
            VStack(spacing: 0) {
                SettingsRow(
                    title: "Terms of Use",
                    icon: "doc.text",
                    iconColor: Color.theme.primaryBlue
                ) {
                    openURL("https://docs.google.com/document/d/1PGZkxPEZEQEH7_WmwpFcVI0d_aQ-3bVJCeCMkfpltdY/edit?usp=sharing")
                }
                
                Divider()
                    .padding(.leading, 50)
                
                SettingsRow(
                    title: "Privacy Policy",
                    icon: "hand.raised",
                    iconColor: Color.theme.primaryPurple
                ) {
                    openURL("https://docs.google.com/document/d/1m6Qk0Gmx5mQYC0LUMcKMwyVAty7rCOJqBR5vIV9h3UQ/edit?usp=sharing")
                }
            }
        }
    }
    
    private var supportSection: some View {
        SettingsSection(title: "Support") {
            VStack(spacing: 0) {
                SettingsRow(
                    title: "Contact Us",
                    icon: "envelope",
                    iconColor: Color.theme.softPink
                ) {
                    openURL("https://forms.gle/XPeRCky4NEx22FN3A")
                }
            }
        }
    }
    
    private var appSection: some View {
        SettingsSection(title: "App") {
            SettingsRow(
                title: "Rate the App",
                icon: "star",
                iconColor: Color.orange
            ) {
                requestReview()
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
                .font(.theme.headline)
                .foregroundColor(Color.theme.primaryText)
                .padding(.horizontal, 16)
            
            VStack(spacing: 0) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.theme.cardGradient)
                    .shadow(color: Color.theme.cardShadow, radius: 4, x: 0, y: 2)
            )
        }
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
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.theme.body)
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.theme.lightText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

#Preview {
    SettingsView()
}
