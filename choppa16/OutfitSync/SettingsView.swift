import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 12) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 50, weight: .light))
                                .foregroundColor(.primaryPurple)
                            
                            Text("Settings")
                                .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                                .foregroundColor(.textPrimary)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 16) {
                            SettingsSection(title: "Legal") {
                                VStack(spacing: 12) {
                                    SettingsRow(
                                        icon: "doc.text",
                                        title: "Terms of Use",
                                        color: .primaryBlue
                                    ) {
                                        openURL("https://www.privacypolicies.com/live/56bdb403-3ed7-4416-b22f-7c705652c1b8")
                                    }
                                    
                                    SettingsRow(
                                        icon: "hand.raised",
                                        title: "Privacy Policy",
                                        color: .primaryPurple
                                    ) {
                                        openURL("https://www.privacypolicies.com/live/8e476c61-6881-4ae3-9e7b-f2b4859f350a")
                                    }
                                }
                            }
                            
                            SettingsSection(title: "Support") {
                                VStack(spacing: 12) {
                                    SettingsRow(
                                        icon: "envelope",
                                        title: "Contact Us",
                                        color: .accentOrange
                                    ) {
                                        openURL("https://www.privacypolicies.com/live/8e476c61-6881-4ae3-9e7b-f2b4859f350a")
                                    }
                                    
                                    SettingsRow(
                                        icon: "star.fill",
                                        title: "Rate the App",
                                        color: .primaryYellow
                                    ) {
                                        requestReview()
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
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
                .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                .foregroundColor(.textPrimary)
                .padding(.leading, 4)
            
            VStack(spacing: 1) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardBackground)
                    .shadow(color: AppShadows.cardShadow, radius: 4, x: 0, y: 2)
            )
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.textSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.cardBackground)
        }
    }
}

struct SettingsInfoRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(color)
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(FontManager.playfairDisplay(size: 14, weight: .regular))
                .foregroundColor(.textSecondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.cardBackground)
    }
}

