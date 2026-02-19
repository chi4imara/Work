import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var dataManager: TermsDataManager
    @Environment(\.requestReview) var requestReview
    @State private var showSampleDataAlert = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 16) {
                        SettingsRowView(
                            icon: "hand.raised",
                            title: "Privacy policy",
                            action: {
                                openURL("https://doc-hosting.flycricket.io/defineme-softly-privacy-policy/45b37a8b-d32d-4626-a0c5-4bfb1e040fa6/privacy")
                            }
                        )
                        
                        SettingsRowView(
                            icon: "envelope",
                            title: "Contact us",
                            action: {
                                openURL("https://forms.gle/K57bXefKiLQfrT6d7")
                            }
                        )
                        
                        SettingsRowView(
                            icon: "star",
                            title: "Rate app",
                            action: {
                                requestReview()
                            }
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .alert("Load sample data", isPresented: $showSampleDataAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Load") {
                dataManager.loadSampleData()
            }
        } message: {
            Text("This will add 9 sample terms to your glossary. Existing terms will be kept. Use this to try the app features.")
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsRowView: View {
    let icon: String
    let title: String
    let subtitle: String?
    let action: (() -> Void)?
    
    init(icon: String, title: String, subtitle: String? = nil, action: (() -> Void)?) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(AppColors.accentYellow)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.ubuntu(14))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
                
                if action != nil {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.primaryText.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .disabled(action == nil)
    }
}

#Preview {
    SettingsView()
        .environmentObject(TermsDataManager())
}
