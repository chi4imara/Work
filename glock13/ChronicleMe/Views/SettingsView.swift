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
                    VStack(spacing: 24) {
                        settingsSection(title: "App") {
                            SettingsRow(
                                title: "Rate the App",
                                icon: "star.fill",
                                color: AppColors.primaryYellow
                            ) {
                                requestReview()
                            }
                        }
                        
                        settingsSection(title: "Legal") {
                            VStack(spacing: 0) {
                                SettingsRow(
                                    title: "Terms of Use",
                                    icon: "doc.text.fill",
                                    color: Color.blue,
                                    showArrow: true
                                ) {
                                    openURL("https://docs.google.com/document/d/1HcTCrt2M24f1KheYt-7cXSgU5o3Kq_sL4w_0KHq4yFM/edit?usp=sharing")
                                }
                                
                                Divider()
                                    .background(AppColors.primaryWhite.opacity(0.1))
                                
                                SettingsRow(
                                    title: "Privacy Policy",
                                    icon: "lock.shield.fill",
                                    color: AppColors.editGreen,
                                    showArrow: true
                                ) {
                                    openURL("https://docs.google.com/document/d/1d4klxvZX7ipQ3w2DM9qRETaoUTmFMmugqp5ZZF_8u-U/edit?usp=sharing")
                                }
                            }
                        }
                        
                        settingsSection(title: "Support") {
                            SettingsRow(
                                title: "Contact Us",
                                icon: "envelope.fill",
                                color: AppColors.deleteRed,
                                showArrow: true
                            ) {
                                openURL("https://forms.gle/GiVrHSaVy52WerZXA")
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private func settingsSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(AppFonts.subheadline)
                .foregroundColor(AppColors.secondaryText)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                content()
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.primaryWhite.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let color: Color
    let showArrow: Bool
    let action: () -> Void
    
    init(
        title: String,
        icon: String,
        color: Color,
        showArrow: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.color = color
        self.showArrow = showArrow
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color.opacity(0.2))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                if showArrow {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .padding(16)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}
