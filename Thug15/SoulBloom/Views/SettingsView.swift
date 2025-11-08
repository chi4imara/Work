import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient.appBackground
                    .ignoresSafeArea()
                
                GridPatternView()
                    .opacity(0.1)
                
                VStack(spacing: 0) {
                    headerView
                    
                    settingsContentView
                }
            }
            .navigationBarHidden(true)
        }
        .alert("Information", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(FontManager.title)
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 15)
        .padding(.top, 8)
        .padding(.bottom, 15)
    }
    
    private var settingsContentView: some View {
        ScrollView {
            VStack(spacing: 25) {
                appInfoSection
                
                legalSection
                
                supportSection
                
                ratingSection
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 80)
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 15) {
            VStack(spacing: 12) {
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(ColorTheme.accentYellow)
                
                Text("SoulBloom")
                    .font(FontManager.headline)
                    .foregroundColor(ColorTheme.primaryText)
            }
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(ColorTheme.cardBackground)
            )
        }
    }
    
    private var legalSection: some View {
        VStack(spacing: 12) {
            Text("Legal")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 8) {
                SettingsRow(
                    icon: "doc.text",
                    title: "Terms of Use",
                    action: { openURL("https://docs.google.com/document/d/1XOhU0-ZrYV8y9qbSv-q8-YRPq-5VaGKtjWsMo8tC_-c/edit?usp=sharing") }
                )
                
                SettingsRow(
                    icon: "hand.raised",
                    title: "Privacy Policy",
                    action: { openURL("https://docs.google.com/document/d/1Mx0roAnHsCzfTLvXouh1Gij41zlSl9VoNAhApLO1iEo/edit?usp=sharing") }
                )
            }
        }
    }
    
    private var supportSection: some View {
        VStack(spacing: 12) {
            Text("Support")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 8) {
                SettingsRow(
                    icon: "envelope",
                    title: "Contact Us",
                    action: { openURL("https://forms.gle/2dTjCPGV1fhiNeLv9") }
                )
            }
        }
    }
    
    private var ratingSection: some View {
        VStack(spacing: 12) {
            Text("Feedback")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 8) {
                SettingsRow(
                    icon: "star",
                    title: "Rate the App",
                    action: { requestAppReview() }
                )
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        } else {
            alertMessage = "Unable to open link"
            showingAlert = true
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(ColorTheme.accentOrange)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(FontManager.callout)
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundColor(ColorTheme.secondaryText)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorTheme.cardBackground)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}
