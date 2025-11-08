import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        appInfoSection
                        
                        legalSection
                        
                        supportSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                Image(systemName: "airplane.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Travel Diary")
                    .font(FontManager.title)
                    .foregroundColor(ColorTheme.primaryText)
            }
            .padding(.vertical, 20)
        }
        .frame(maxWidth: .infinity)
        .background(
            ColorTheme.cardGradient
                .cornerRadius(16)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.borderColor, lineWidth: 1)
        )
    }
    
    private var legalSection: some View {
        VStack(spacing: 0) {
            Text("Legal")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 16)
            
            VStack(spacing: 1) {
                SettingsRow(
                    title: "Terms of Use",
                    icon: "doc.text"
                ) {
                    openURL("https://docs.google.com/document/d/1r84z0G6q4zOH5Wx_xEVaZzKH6aHKFyMgar0zsiaTkpo/edit?usp=sharing")
                }
                
                Divider()
                    .background(ColorTheme.borderColor)
                
                SettingsRow(
                    title: "Privacy Policy",
                    icon: "hand.raised"
                ) {
                    openURL("https://docs.google.com/document/d/15DtDBNrXimuTxog4em4yLa-_C6tGS-h1N50w8283KZw/edit?usp=sharing")
                }
                
                Divider()
                    .background(ColorTheme.borderColor)
            }
            .background(
                ColorTheme.cardGradient
                    .cornerRadius(12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(ColorTheme.borderColor, lineWidth: 1)
            )
        }
    }
    
    private var supportSection: some View {
        VStack(spacing: 0) {
            Text("Support")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 16)
            
            VStack(spacing: 1) {
                SettingsRow(
                    title: "Contact Us",
                    icon: "envelope"
                ) {
                    openURL("https://forms.gle/xDvf4sjzz6qbfnsy6")
                }
                
                Divider()
                    .background(ColorTheme.borderColor)
                
                SettingsRow(
                    title: "Rate App",
                    icon: "star"
                ) {
                    requestAppReview()
                }
            }
            .background(
                ColorTheme.cardGradient
                    .cornerRadius(12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(ColorTheme.borderColor, lineWidth: 1)
            )
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

struct SettingsRow: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorTheme.accent)
                    .frame(width: 24)
                
                Text(title)
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(ColorTheme.borderColor)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}

