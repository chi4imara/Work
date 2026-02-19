import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            AppColorScheme.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        settingsSection(title: "App") {
                            SettingsRowView(
                                icon: SystemImages.starFill,
                                title: "Rate App",
                                iconColor: .primaryYellow
                            ) {
                                requestReview()
                            }
                        }
                        
                        settingsSection(title: "Support") {
                            SettingsRowView(
                                icon: SystemImages.envelope,
                                title: "Contact Us",
                                iconColor: .accentBlue
                            ) {
                                openURL(AppConstants.URLs.contactEmail)
                            }
                        }
                        
                        settingsSection(title: "Legal") {
                            SettingsRowView(
                                icon: SystemImages.docText,
                                title: "Privacy Policy",
                                iconColor: .accentPurple
                            ) {
                                openURL(AppConstants.URLs.privacyPolicy)
                            }
                        }
                        
                        VStack(spacing: 15) {
                            Text(AppConstants.appName)
                                .font(.playfairDisplay(20, weight: .bold))
                                .foregroundColor(.textPrimary)
                            
                            Text(AppConstants.appDescription)
                                .font(.playfairDisplay(12, weight: .regular))
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 30)
                        .padding(.bottom, 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(.textSecondary)
                .padding(.horizontal, 20)
            
            VStack(spacing: 1) {
                content()
            }
            .background(AppColorScheme.cardGradient)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
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
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(iconColor)
                    .frame(width: 30, height: 30)
                
                Text(title)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    SettingsView()
}
