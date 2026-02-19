import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Settings")
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                
                ScrollView {
                    VStack(spacing: 24) {
                        SettingsSection(title: "App") {
                            SettingsRow(
                                title: "Rate App",
                                icon: "star.fill",
                                iconColor: AppColors.orange,
                                action: { requestReview() }
                            )
                        }
                        
                        SettingsSection(title: "Legal") {
                            SettingsRow(
                                title: "Privacy Policy",
                                icon: "shield.fill",
                                iconColor: AppColors.green,
                                action: {
                                    openURL("https://www.privacypolicies.com/live/123855e6-a7c5-4c5f-b5e8-55de18d6ecbe")
                                }
                            )
                        }
                        
                        SettingsSection(title: "Support") {
                            SettingsRow(
                                title: "Contact Us",
                                icon: "envelope.fill",
                                iconColor: AppColors.lightBlue,
                                action: {
                                    openURL("https://www.privacypolicies.com/live/123855e6-a7c5-4c5f-b5e8-55de18d6ecbe")
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }

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
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.playfairDisplay(size: 18, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 20)
            
            VStack(spacing: 1) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardGradient)
            )
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(iconColor)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.clear)
        }
    }
}

struct SettingsInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.playfairDisplay(size: 16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Text(value)
                .font(.playfairDisplay(size: 16, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

#Preview {
    SettingsView()
}
