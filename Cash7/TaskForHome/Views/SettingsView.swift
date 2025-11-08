import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        appInfoSection
                        
                        legalSection
                        
                        supportSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(20)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.customTitle())
                .foregroundColor(.pureWhite)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                Image(systemName: "sparkles")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(.primaryBlue)
                    .padding(20)
                    .background(Color.pureWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                Text("Clean Home")
                    .font(.customHeadline())
                    .foregroundColor(.pureWhite)
            }
            .padding(.vertical, 20)
        }
    }
    
    private var legalSection: some View {
        VStack(spacing: 12) {
            Text("Legal")
                .font(.customSubheadline())
                .foregroundColor(.pureWhite)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 8) {
                SettingsRow(
                    icon: "doc.text",
                    title: "Terms of Use",
                    action: {
                        openURL("https://google.com")
                    }
                )
                
                SettingsRow(
                    icon: "hand.raised",
                    title: "Privacy Policy",
                    action: {
                        openURL("https://google.com")
                    }
                )
            }
        }
    }
    
    private var supportSection: some View {
        VStack(spacing: 12) {
            Text("Support")
                .font(.customSubheadline())
                .foregroundColor(.pureWhite)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 8) {
                SettingsRow(
                    icon: "envelope",
                    title: "Contact Us",
                    action: {
                        openURL("https://google.com")
                    }
                )
                
                SettingsRow(
                    icon: "star",
                    title: "Rate the App",
                    action: {
                        requestReview()
                    }
                )
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.primaryBlue)
                    .frame(width: 24)
                
                Text(title)
                    .font(.customBody())
                    .foregroundColor(.darkGray)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.mediumGray)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cardGradient)
            )
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}

