import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    @State private var showingResetOnboardingAlert = false
    
    var body: some View {
            ZStack {
                BackgroundView()
                
                VStack {
                    
                    HStack {
                        Text("Settings")
                            .font(FontManager.largeTitle)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    .background(BackgroundView())
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            headerView
                            
                            VStack(spacing: 24) {
                                HStack(spacing: 16) {
                                    SettingsCard(
                                        icon: "doc.text",
                                        title: "Terms of Use",
                                        subtitle: "Legal information",
                                        color: AppColors.primaryBlue,
                                        action: {
                                            openURL("https://docs.google.com/document/d/1UE6TP_IuHebSk_JQaqFC5mEu5rtTMY8MdSacLwM4d44/edit?usp=sharing")
                                        }
                                    )
                                    .frame(maxWidth: .infinity)
                                    
                                    SettingsCard(
                                        icon: "envelope",
                                        title: "Contact",
                                        subtitle: "Get in touch",
                                        color: AppColors.completedColor,
                                        action: {
                                            openURL("https://forms.gle/Eu6eUfTmAukR5CzP7")
                                        }
                                    )
                                    .frame(maxWidth: .infinity)

                                }
                                HStack(spacing: 16) {
                                    SettingsCard(
                                        icon: "star",
                                        title: "Rate App",
                                        subtitle: "Leave a review",
                                        color: AppColors.warningColor,
                                        action: {
                                            requestReview()
                                        }
                                    )
                                    .frame(maxWidth: .infinity)

                                    SettingsCard(
                                        icon: "shield",
                                        title: "Privacy Policy",
                                        subtitle: "Data protection",
                                        color: AppColors.destructiveColor,
                                        action: {
                                            openURL("https://docs.google.com/document/d/1tOCUBR37GIK48uxKWiYfgUgtkI_5QWOGlDGOuz9oqGY/edit?usp=sharing")
                                        }
                                    )
                                    .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        .alert("Reset Onboarding", isPresented: $showingResetOnboardingAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                resetOnboarding()
            }
        } message: {
            Text("This will show the onboarding screen again on next app launch. This is useful for testing.")
        }
    }
    
    private var developerSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Developer")
                .font(FontManager.headline)
                .foregroundColor(AppColors.primaryText)
            
            Button(action: {
                showingResetOnboardingAlert = true
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.warningColor)
                    
                    Text("Reset Onboarding")
                        .font(FontManager.body)
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                .padding(16)
                .background(
                    ZStack {
                           RoundedRectangle(cornerRadius: 12)
                               .fill(AppColors.cardBackground)
                           RoundedRectangle(cornerRadius: 12)
                               .stroke(AppColors.lightBlue.opacity(0.5), lineWidth: 1)
                       }
                )
            }
        }
    }
    
    private func resetOnboarding() {
        UserDefaults.standard.set(false, forKey: "hasShownOnboarding")
    }
}
    
    private var headerView: some View {
        VStack(spacing: 16) {
            Text("Customize your reading experience")
                .font(FontManager.body)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
    
    private let miniCardIcons = ["gear", "info.circle", "bell", "bookmark"]
    private let miniCardColors = [AppColors.primaryBlue, AppColors.completedColor, AppColors.warningColor, AppColors.destructiveColor]
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }


struct SettingsCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(color)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(FontManager.subheadline)
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    Text(subtitle)
                        .font(FontManager.caption)
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
            )
        }
        .padding(.horizontal, 3)
        .padding(.vertical, 3)
        .buttonStyle(PlainButtonStyle())
    }
}

struct MiniSettingsCard: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(color)
                        .shadow(color: color.opacity(0.3), radius: 5, x: 0, y: 2)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct WaveSettingsRow: View {
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<3, id: \.self) { index in
                WaveSettingsCard(
                    icon: waveIcons[index],
                    title: waveTitles[index],
                    color: waveColors[index],
                    offset: CGFloat(index * 20),
                    action: {
                        openURL("https://google.com")
                    }
                )
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private let waveIcons = ["doc.plaintext", "lock.shield", "at"]
    private let waveTitles = ["License", "Data Policy", "Contact Email"]
    private let waveColors = [AppColors.primaryBlue, AppColors.completedColor, AppColors.warningColor]
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct WaveSettingsCard: View {
    let icon: String
    let title: String
    let color: Color
    let offset: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(color.opacity(0.1))
                    )
                
                Text(title)
                    .font(FontManager.caption)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.cardGradient)
                    .shadow(color: color.opacity(0.1), radius: 5, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .offset(y: offset)
    }
}
