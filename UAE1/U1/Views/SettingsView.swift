import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        settingsSection
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        
                        footerSection
                            .padding(.horizontal, 20)
                            .padding(.bottom, 120)
                    }
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(FontManager.ubuntu(28, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var settingsSection: some View {
        VStack(spacing: 16) {
            SettingsRowView(
                title: "Privacy Policy",
                icon: "shield.checkerboard",
                action: {
                    openURL("https://www.privacypolicies.com/live/730d76ae-7d87-4b8d-a78b-2d0386106c4b")
                }
            )
            
            Divider()
                .overlay {
                    Color.white
                }
                .padding(.horizontal, -20)
                .frame(maxWidth: .infinity)
            
            SettingsRowView(
                title: "Contact Us",
                icon: "envelope",
                action: {
                    openURL("https://www.privacypolicies.com/live/730d76ae-7d87-4b8d-a78b-2d0386106c4b")
                }
            )
            
            Divider()
                .overlay {
                    Color.white
                }
                .padding(.horizontal, -20)
                .frame(maxWidth: .infinity)
            
            SettingsRowView(
                title: "Rate the App",
                icon: "star",
                action: {
                    requestReview()
                }
            )
        }
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
    }
    
    private var footerSection: some View {
        VStack(spacing: 12) {
            VStack(spacing: 8) {
                Image(systemName: "scissors")
                    .font(.system(size: 32, weight: .light))
                    .foregroundColor(ColorManager.accent)
                
                Text("Beard Care Tracker")
                    .font(FontManager.ubuntu(18, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
            }
            .padding(.vertical, 20)
            
            Text("Keep track of your beard care routine")
                .font(FontManager.ubuntu(12, weight: .regular))
                .foregroundColor(ColorManager.tertiaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 20)
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsRowView: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(ColorManager.accentGradient)
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(ColorManager.primaryText)
                }
                
                Text(title)
                    .font(FontManager.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(ColorManager.tertiaryText)
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview {
    SettingsView()
}
