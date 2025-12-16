import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            settingsContent
        }
        .background(ColorManager.backgroundGradient)
        .alert("Rate BrushBook", isPresented: $showingRateAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Rate Now") {
                requestReview()
            }
        } message: {
            Text("Enjoying BrushBook? Please take a moment to rate us in the App Store!")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var settingsContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                appInfoSection
                
                legalSection
                
                supportSection
                
                rateAppSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(ColorManager.primaryButton)
                        .frame(width: 80, height: 80)
                        .shadow(color: ColorManager.cardShadow, radius: 15, x: 0, y: 8)
                    
                    Image(systemName: "paintbrush.pointed.fill")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 4) {
                    Text("BrushBook")
                        .font(.playfairDisplay(24, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Text("Beauty Tools Catalog")
                        .font(.playfairDisplay(16))
                        .foregroundColor(ColorManager.secondaryText)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(ColorManager.cardGradient)
                .shadow(color: ColorManager.shadowColor, radius: 15, x: 0, y: 8)
        )
    }
    
    private var legalSection: some View {
        SettingsSection(title: "Legal") {
            SettingsRow(
                title: "Terms of Use",
                icon: "doc.text",
                action: { openURL("https://www.termsfeed.com/live/2252e596-17ea-4316-b40c-675637334404") }
            )
            
            SettingsRow(
                title: "Privacy Policy",
                icon: "hand.raised",
                action: { openURL("https://www.termsfeed.com/live/98412e4e-92fb-4c4a-9f35-1c7f4284477b") }
            )
        }
    }
    
    private var supportSection: some View {
        SettingsSection(title: "Support") {
            SettingsRow(
                title: "Contact Us",
                icon: "envelope",
                action: { openURL("https://www.termsfeed.com/live/98412e4e-92fb-4c4a-9f35-1c7f4284477b") }
            )
        }
    }
    
    private var rateAppSection: some View {
        SettingsSection(title: "Feedback") {
            SettingsRow(
                title: "Rate App",
                icon: "star",
                action: { showingRateAlert = true }
            )
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
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
                .foregroundColor(ColorManager.primaryText)
                .padding(.horizontal, 4)
            
            VStack(spacing: 1) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorManager.cardGradient)
                    .shadow(color: ColorManager.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .frame(width: 24)
                
                Text(title)
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(ColorManager.secondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.clear)
        }
    }
}
