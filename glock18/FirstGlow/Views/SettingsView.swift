import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackgroundView()
                
                VStack(spacing: 0) {
                    headerView
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            appInfoSection
                            
                            legalSection
                            
                            supportSection
                            
                            ratingSection
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Settings")
                    .font(FontManager.largeTitle)
                    .foregroundColor(AppColors.pureWhite)
                
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.accentYellow)
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "star.fill")
                            .font(.system(size: 40, weight: .medium))
                            .foregroundColor(AppColors.darkGray)
                    )
                
                VStack(spacing: 4) {
                    Text("FirstGlow")
                        .font(FontManager.title2)
                        .foregroundColor(AppColors.pureWhite)
                }
            }
            .padding(.vertical, 20)
        }
        .frame(maxWidth: .infinity)
        .cardBackground()
    }
    
    private var legalSection: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "Legal")
            
            VStack(spacing: 1) {
                SettingsRow(
                    icon: "doc.text",
                    title: "Terms of Use",
                    color: AppColors.lightPurple
                ) {
                    openURL("https://docs.google.com/document/d/1O60AZUh5UNzIAh4nlVAFvUHQtc3SLaHW-ARcya0J1rk/edit?usp=sharing")
                }
                
                Divider()
                    .background(AppColors.mediumGray.opacity(0.3))
                    .padding(.leading, 56)
                
                SettingsRow(
                    icon: "hand.raised",
                    title: "Privacy Policy",
                    color: AppColors.softPink
                ) {
                    openURL("https://docs.google.com/document/d/1RJ1EkhJCtmM_qLBgT4q7RgREL4lAVJHr_iY0QL8WLf4/edit?usp=sharing")
                }
                
                Divider()
                    .background(AppColors.mediumGray.opacity(0.3))
                    .padding(.leading, 56)
                
                SettingsRow(
                    icon: "checkmark.shield",
                    title: "License Agreement",
                    color: AppColors.mintGreen
                ) {
                    openURL("https://google.com")
                }
            }
            .cardBackground()
        }
    }
    
    private var supportSection: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "Support")
            
            VStack(spacing: 1) {
                SettingsRow(
                    icon: "envelope",
                    title: "Contact Us",
                    color: AppColors.peachOrange
                ) {
                    openURL("https://forms.gle/w3zxiqWXTdTbhM738")
                }
                
                Divider()
                    .background(AppColors.mediumGray.opacity(0.3))
                    .padding(.leading, 56)
                
                SettingsRow(
                    icon: "questionmark.circle",
                    title: "Help & FAQ",
                    color: AppColors.lightPurple
                ) {
                    openURL("https://google.com")
                }
            }
            .cardBackground()
        }
    }
    
    private var ratingSection: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "Feedback")
            
            VStack(spacing: 1) {
                SettingsRow(
                    icon: "star",
                    title: "Rate the App",
                    color: AppColors.accentYellow
                ) {
                    requestReview()
                }
                
                Divider()
                    .background(AppColors.mediumGray.opacity(0.3))
                    .padding(.leading, 56)
                
                SettingsRow(
                    icon: "heart",
                    title: "Leave a Review",
                    color: AppColors.softPink
                ) {
                    requestReview()
                }
            }
            .cardBackground()
        }
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(FontManager.headline)
                .foregroundColor(AppColors.pureWhite.opacity(0.9))
            
            Spacer()
        }
        .padding(.horizontal, 4)
        .padding(.bottom, 8)
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
                    .font(FontManager.body)
                    .foregroundColor(AppColors.darkGray)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.mediumGray.opacity(0.6))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CreativeSettingsView: View {
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackgroundView()
                
                VStack(spacing: 0) {
                    headerView
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            appInfoCard
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                
                                SettingCard(
                                    icon: "doc.text",
                                    title: "Terms",
                                    subtitle: "User Agreement",
                                    color: AppColors.lightPurple
                                ) {
                                    openURL("https://docs.google.com/document/d/1O60AZUh5UNzIAh4nlVAFvUHQtc3SLaHW-ARcya0J1rk/edit?usp=sharing")
                                }
                                
                                SettingCard(
                                    icon: "hand.raised",
                                    title: "Privacy",
                                    subtitle: "Data Protection",
                                    color: AppColors.softPink
                                ) {
                                    openURL("https://docs.google.com/document/d/1RJ1EkhJCtmM_qLBgT4q7RgREL4lAVJHr_iY0QL8WLf4/edit?usp=sharing")
                                }
                                
                                SettingCard(
                                    icon: "envelope",
                                    title: "Contact",
                                    subtitle: "Get in Touch",
                                    color: AppColors.peachOrange
                                ) {
                                    openURL("https://forms.gle/w3zxiqWXTdTbhM738")
                                }
                                
                                SettingCard(
                                    icon: "star",
                                    title: "Rate App",
                                    subtitle: "Share Feedback",
                                    color: AppColors.accentYellow
                                ) {
                                    requestReview()
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Settings")
                    .font(FontManager.largeTitle)
                    .foregroundColor(AppColors.pureWhite)
                
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var appInfoCard: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.accentYellow)
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "star.fill")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundColor(AppColors.darkGray)
                )
            
            VStack(spacing: 4) {
                Text("FirstGlow")
                    .font(FontManager.title3)
                    .foregroundColor(AppColors.darkGray)
                
                Text("Capture Your First Times")
                    .font(FontManager.caption1)
                    .foregroundColor(AppColors.mediumGray)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .cardBackground()
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}

struct SettingCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(color)
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(FontManager.headline)
                        .foregroundColor(AppColors.darkGray)
                    
                    Text(subtitle)
                        .font(FontManager.caption1)
                        .foregroundColor(AppColors.mediumGray)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
        }
        .cardBackground()
    }
}


#Preview("Standard Settings") {
    SettingsView()
}

#Preview("Creative Settings") {
    CreativeSettingsView()
}
