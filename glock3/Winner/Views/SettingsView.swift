import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(AppColors.textPrimary)
                            .frame(width: 44, height: 44)
                            .background(AppColors.cardBackground)
                            .cornerRadius(12)
                            .opacity(0)
                    }
                    .disabled(true)
                    
                    Text("Settings")
                        .font(AppFonts.navigationTitle)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                
                ScrollView {
                    VStack(spacing: 20) {
                        SettingsSectionView(title: "App") {
                            VStack(spacing: 12) {
                                SettingsRowView(
                                    iconName: "star.fill",
                                    title: "Rate App",
                                    iconColor: AppColors.primaryYellow
                                ) {
                                    requestReview()
                                }
                            }
                        }
                        
                        SettingsSectionView(title: "Legal") {
                            VStack(spacing: 12) {
                                SettingsRowView(
                                    iconName: "doc.text.fill",
                                    title: "Terms of Use",
                                    iconColor: AppColors.accentGreen
                                ) {
                                    openURL("https://docs.google.com/document/d/1CGRqlMbrioT-WmVNN6tl8BwIWlk1-Osfc0x_zOZMLko/edit?usp=sharing")
                                }
                                
                                Divider()
                                    .overlay {
                                        Color.white
                                    }
                                
                                SettingsRowView(
                                    iconName: "hand.raised.fill",
                                    title: "Privacy Policy",
                                    iconColor: AppColors.accentOrange
                                ) {
                                    openURL("https://docs.google.com/document/d/1Kg3UhfVQrD0IatBkskvkB4fcRxRnMbGEmG0qGoazBgM/edit?usp=sharing")
                                }
                            }
                        }
                        
                        SettingsSectionView(title: "Support") {
                            VStack(spacing: 12) {
                                SettingsRowView(
                                    iconName: "envelope.fill",
                                    title: "Contact Us",
                                    iconColor: AppColors.accentPurple
                                ) {
                                    openURL("https://forms.gle/8qaWSYQg9kzQhPMw9")
                                }
                            }
                        }
                        
                        VStack(spacing: 8) {
                            Text("Small Wins")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.textPrimary)

                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 100)
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
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)
                .padding(.horizontal, 4)
            
            VStack(spacing: 1) {
                content
            }
            .background(AppColors.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
        }
    }
}

struct SettingsRowView: View {
    let iconName: String
    let title: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: iconName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                Text(title)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textTertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.clear)
        }
    }
}

#Preview {
    SettingsView()
}
