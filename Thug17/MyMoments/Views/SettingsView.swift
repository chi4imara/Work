import SwiftUI
import StoreKit

struct SettingsView: View {
    let sidebarToggleButton: AnyView
    @State private var showingRateAlert = false
    
    init(sidebarToggleButton: some View) {
        self.sidebarToggleButton = AnyView(sidebarToggleButton)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                settingsContentView
            }
        }
        .alert("Rate Our App", isPresented: $showingRateAlert) {
            Button("Rate Now") {
                requestAppReview()
            }
            Button("Later", role: .cancel) { }
        } message: {
            Text("If you enjoy using MyMoments, please take a moment to rate it. It really helps us!")
        }
    }
    
    private var headerView: some View {
        HStack {
            sidebarToggleButton
                .disabled(true)
                .opacity(0)
            
            Text("Settings")
                .font(.screenTitle)
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
    }
    
    private var settingsContentView: some View {
        ScrollView {
            VStack(spacing: 20) {
                appSection
                
                legalSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
    }
    
    private var appSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("App")
                .font(.cardTitle)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 0) {
                SettingsRowView(
                    title: "Rate the App",
                    icon: "star.fill",
                    action: {
                        showingRateAlert = true
                    }
                )
                
                Divider()
                    .padding(.leading, 44)
                
                SettingsRowView(
                    title: "Contact Us",
                    icon: "envelope.fill",
                    action: {
                        openURL(Constants.URLs.contactEmail)
                    }
                )
            }
            .background(Color.cardBackground)
            .cornerRadius(12)
            .shadow(color: .shadowColor, radius: 4, x: 0, y: 2)
        }
    }
    
    private var legalSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Legal")
                .font(.cardTitle)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 0) {
                SettingsRowView(
                    title: "Terms of Use",
                    icon: "doc.text.fill",
                    action: {
                        openURL(Constants.URLs.termsOfUse)
                    }
                )
                
                Divider()
                    .padding(.leading, 44)
                
                SettingsRowView(
                    title: "Privacy Policy",
                    icon: "lock.shield.fill",
                    action: {
                        openURL(Constants.URLs.privacyPolicy)
                    }
                )
            }
            .background(Color.cardBackground)
            .cornerRadius(12)
            .shadow(color: .shadowColor, radius: 4, x: 0, y: 2)
        }
    }
    
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Support")
                .font(.cardTitle)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 0) {
                SettingsRowView(
                    title: "User Agreement",
                    icon: "person.fill.checkmark",
                    action: {
                        openURL(Constants.URLs.userAgreement)
                    }
                )
                
                Divider()
                    .padding(.leading, 44)
                
                SettingsRowView(
                    title: "Email Support",
                    icon: "questionmark.circle.fill",
                    action: {
                        openURL(Constants.URLs.emailSupport)
                    }
                )
            }
            .background(Color.cardBackground)
            .cornerRadius(12)
            .shadow(color: .shadowColor, radius: 4, x: 0, y: 2)
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

struct SettingsRowView: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.primaryBlue)
                    .frame(width: 24)
                
                Text(title)
                    .font(.bodyText)
                    .foregroundColor(.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

#Preview {
    SettingsView(sidebarToggleButton: Button("Toggle") { })
}
