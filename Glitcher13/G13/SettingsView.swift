import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Settings")
                        .font(.playfair(28, weight: .bold))
                        .foregroundColor(AppColors.blueText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 20) {
                        SettingsSectionView(title: "App Information") {
                            VStack(spacing: 12) {
                                SettingsRowView(
                                    icon: "star.fill",
                                    title: "Rate App",
                                    iconColor: AppColors.yellow
                                ) {
                                    requestReview()
                                }
                                
                                Divider()
                                
                                SettingsRowView(
                                    icon: "envelope.fill",
                                    title: "Contact Us",
                                    iconColor: AppColors.lightBlue
                                ) {
                                    openURL("https://www.termsfeed.com/live/fc0f8f31-d243-45f9-acff-24af13fe1bdf")
                                }
                            }
                        }
                        
                        SettingsSectionView(title: "Legal") {
                            VStack(spacing: 12) {
                                SettingsRowView(
                                    icon: "doc.text.fill",
                                    title: "Privacy Policy",
                                    iconColor: AppColors.purple
                                ) {
                                    openURL("https://www.termsfeed.com/live/fc0f8f31-d243-45f9-acff-24af13fe1bdf")
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
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

struct SettingsSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.playfair(18, weight: .semibold))
                    .foregroundColor(AppColors.blueText)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardGradient)
            )
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
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(.playfair(16, weight: .medium))
                    .foregroundColor(AppColors.blueText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(AppColors.mediumGray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
    }
}

#Preview {
    NavigationView {
        SettingsView()
    }
}
