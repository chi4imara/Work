import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        SettingsSection(title: "App") {
                            SettingsRow(
                                title: "Rate App",
                                icon: "star.fill",
                                action: {
                                    requestReview()
                                }
                            )
                        }
                        
                        SettingsSection(title: "Legal") {
                            SettingsRow(
                                title: "Terms and Conditions",
                                icon: "doc.text.fill",
                                action: {
                                    openURL("https://www.freeprivacypolicy.com/live/c07e67dd-1af0-4f55-831d-f24c4ff2662a")
                                }
                            )
                            
                            SettingsRow(
                                title: "Privacy Policy",
                                icon: "hand.raised.fill",
                                action: {
                                    openURL("https://www.freeprivacypolicy.com/live/4477b838-62ef-4e06-b8be-06be9c360bab")
                                }
                            )
                        }
                        
                        SettingsSection(title: "Support") {
                            SettingsRow(
                                title: "Contact Us",
                                icon: "envelope.fill",
                                action: {
                                    openURL("https://forms.gle/4VR7vtaCxej4WM6y9")
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
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
                .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                .foregroundColor(AppColors.accentYellow)
                .padding(.horizontal, 4)
            
            VStack(spacing: 1) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
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
                    .foregroundColor(AppColors.accentYellow)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    SettingsView()
}
