import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        appInfoSection
                        
                        legalSection
                        
                        supportSection
                        
                        appVersionSection
                        
                        Spacer(minLength: 100) 
                    }
                    .padding(20)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(AppFonts.navigationTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.primaryGradient)
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 40, weight: .medium))
                            .foregroundColor(AppColors.onPrimary)
                    )
                
                VStack(spacing: 4) {
                    Text("HobbyRadar")
                        .font(AppFonts.title3)
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Your Leisure Idea Generator")
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .padding(.vertical, 20)
            
            SettingsButton(
                title: "Rate Our App",
                subtitle: "Help us improve with your feedback",
                icon: "star.fill",
                iconColor: AppColors.warning
            ) {
                requestAppReview()
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.primary.opacity(0.1), radius: 6, x: 0, y: 3)
        )
    }
    
    private var legalSection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Legal")
            
            VStack(spacing: 0) {
                SettingsButton(
                    title: "Terms & Conditions",
                    subtitle: "Review our terms of service",
                    icon: "doc.text",
                    showArrow: true
                ) {
                    openURL("https://docs.google.com/document/d/16rT3PDvtYaMm2BCnuI6Az2-kdNthK3nhI3wbrG9SgIY/edit?usp=sharing")
                }
                
                Divider()
                    .padding(.leading, 60)
                
                SettingsButton(
                    title: "Privacy Policy",
                    subtitle: "Learn about data protection",
                    icon: "lock.shield",
                    showArrow: true
                ) {
                    openURL("https://docs.google.com/document/d/1QFeETexpOZ60oNRkVAtQ7V7xbA4ukaH3X1Ax3Ha-hYQ/edit?usp=sharing")
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
            )
        }
    }
    
    private var supportSection: some View {
        VStack(spacing: 12) {
            SectionHeader(title: "Support")
            
            VStack(spacing: 0) {
                SettingsButton(
                    title: "Contact Us",
                    subtitle: "Get help and support",
                    icon: "envelope",
                    showArrow: true
                ) {
                    openURL("https://forms.gle/QWmiJ43WYJjhihRi9")
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
            )
        }
    }
    
    private var appVersionSection: some View {
        VStack(spacing: 8) {
            Text("Made with ❤️ for leisure enthusiasts")
                .font(AppFonts.caption1)
                .foregroundColor(AppColors.lightText)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsButton: View {
    let title: String
    let subtitle: String?
    let icon: String
    let iconColor: Color
    let showArrow: Bool
    let action: () -> Void
    
    init(
        title: String,
        subtitle: String? = nil,
        icon: String,
        iconColor: Color = AppColors.primary,
        showArrow: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.iconColor = iconColor
        self.showArrow = showArrow
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.primaryText)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(AppFonts.footnote)
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
                
                Spacer()
                
                if showArrow {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.lightText)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(AppFonts.headline)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
        }
    }
}

struct CreativeSettingsLayout: View {
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                ZStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Settings")
                                .font(AppFonts.title1)
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Customize your experience")
                                .font(AppFonts.callout)
                                .foregroundColor(AppColors.secondaryText)
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(AppColors.primary.opacity(0.1))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(AppColors.primary)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                
                GeometryReader { geometry in
                    let itemWidth = (geometry.size.width - 60) / 2
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            HexagonalSettingsCard(
                                title: "Rate App",
                                icon: "star.fill",
                                color: AppColors.warning,
                                width: itemWidth
                            ) {
                            }
                            
                            HexagonalSettingsCard(
                                title: "Privacy",
                                icon: "lock.shield.fill",
                                color: AppColors.success,
                                width: itemWidth
                            ) {
                            }
                        }
                        
                        HStack(spacing: 20) {
                            HexagonalSettingsCard(
                                title: "Terms",
                                icon: "doc.text.fill",
                                color: AppColors.primary,
                                width: itemWidth
                            ) {
                            }
                            
                            HexagonalSettingsCard(
                                title: "Contact",
                                icon: "envelope.fill",
                                color: AppColors.accent,
                                width: itemWidth
                            ) {
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
    }
}

struct HexagonalSettingsCard: View {
    let title: String
    let icon: String
    let color: Color
    let width: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(color.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
            }
            .frame(width: width, height: 120)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.cardGradient)
                    .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
}
