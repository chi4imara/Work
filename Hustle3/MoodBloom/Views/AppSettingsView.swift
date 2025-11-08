import SwiftUI
import StoreKit

struct AppSettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 24) {
                        appInfoSection
                        
                        supportSection
                        
                        legalSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(FontManager.title)
                .foregroundColor(Color.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var appInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("App Information")
                .font(FontManager.headline)
                .foregroundColor(Color.textPrimary)
            
            VStack(spacing: 12) {
                Button(action: {
                    requestReview()
                }) {
                    settingsRowContent(
                        title: "Rate App",
                        icon: "star",
                        showArrow: true
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundWhite)
                .shadow(color: Color.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Support")
                .font(FontManager.headline)
                .foregroundColor(Color.textPrimary)
            
            VStack(spacing: 12) {
                Button(action: {
                    openURL("https://forms.gle/U33b9eNYXkHdTGwY9")
                }) {
                    settingsRowContent(
                        title: "Contact Us",
                        icon: "envelope",
                        showArrow: true
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundWhite)
                .shadow(color: Color.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var legalSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Legal")
                .font(FontManager.headline)
                .foregroundColor(Color.textPrimary)
            
            VStack(spacing: 12) {
                Button(action: {
                    openURL("https://docs.google.com/document/d/1ZHYM9x92qbBt3IMtrP4QlMCqS1pmc4dDfex8s_ZHgcs/edit?usp=sharing")
                }) {
                    settingsRowContent(
                        title: "Terms of Use",
                        icon: "doc.text",
                        showArrow: true
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    openURL("https://docs.google.com/document/d/1v4eOqUANive1gReia7Eag2xJsWCUre9Oy8PWXx5IMto/edit?usp=sharing")
                }) {
                    settingsRowContent(
                        title: "Privacy Policy",
                        icon: "hand.raised",
                        showArrow: true
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundWhite)
                .shadow(color: Color.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private func settingsRow(title: String, value: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color.primaryBlue)
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(FontManager.body)
                .foregroundColor(Color.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(FontManager.body)
                .foregroundColor(Color.textSecondary)
        }
        .padding(.vertical, 8)
    }
    
    private func settingsRowContent(title: String, icon: String, showArrow: Bool = false) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color.primaryBlue)
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(FontManager.body)
                .foregroundColor(Color.textPrimary)
            
            Spacer()
            
            if showArrow {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.textSecondary)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}

#Preview {
    AppSettingsView()
}
