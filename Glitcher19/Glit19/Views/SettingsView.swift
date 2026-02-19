import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                settingsContentView
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var settingsContentView: some View {
        ScrollView {
            VStack(spacing: 16) {
                SettingsItemView(
                    icon: "shield.checkered",
                    title: "Privacy Policy",
                    subtitle: "Learn how we protect your data"
                ) {
                    openURL("https://doc-hosting.flycricket.io/inmind-petals-privacy-policy/d1a56fdc-e1ac-4c66-91f6-db39264c0778/privacy")
                }
                
                SettingsItemView(
                    icon: "envelope",
                    title: "Contact Us",
                    subtitle: "Get in touch with our support team"
                ) {
                    openURL("https://forms.gle/GqSAsWk6SuZa3WgDA")
                }
                
                SettingsItemView(
                    icon: "star",
                    title: "Rate the App",
                    subtitle: "Help us improve with your feedback"
                ) {
                    requestReview()
                }
                
                VStack(spacing: 8) {
                    Text("Inspiration Notes")
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                }
                .padding(.top, 20)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsItemView: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.theme.accentYellow.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(Color.theme.accentYellow)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Text(subtitle)
                        .font(.ubuntu(13))
                        .foregroundColor(Color.theme.secondaryText)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.theme.secondaryText)
            }
            .padding(16)
            .background(Color.theme.cardGradient)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

#Preview {
    SettingsView()
}
