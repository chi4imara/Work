import SwiftUI

struct SettingsView: View {
    @ObservedObject var appViewModel: AppViewModel
    @Binding var showingSidebar: Bool

    var body: some View {
        ZStack {
            AppTheme.backgroundGradient
                .ignoresSafeArea()
            
            GridBackgroundView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                UniversalHeaderView(
                    title: "Settings",
                    onMenuTap: { showingSidebar = true }
                )
                
                ScrollView {
                    VStack(spacing: 32) {
                        ModernSettingsLayout(appViewModel: appViewModel)
                        
                        AppInfoSection()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 32)
                    .padding(.bottom, 100)
                }
            }
        }
    }
}

struct ModernSettingsLayout: View {
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                SettingsCardView(
                    icon: "star.fill",
                    title: "Rate App",
                    subtitle: "Help us improve",
                    color: AppTheme.primaryYellow,
                    action: {
                        appViewModel.requestAppReview()
                    }
                )
                
                SettingsCardView(
                    icon: "envelope.fill",
                    title: "Contact Us",
                    subtitle: "Get in touch",
                    color: AppTheme.statusGreen,
                    action: {
                        openURL("https://www.privacypolicies.com/live/4059940b-e49a-439a-a6b5-97bdfbbf64de")
                    }
                )
                
                SettingsCardView(
                    icon: "doc.text.fill",
                    title: "Terms of Use",
                    subtitle: "Legal information",
                    color: AppTheme.statusRed,
                    action: {
                        openURL("https://www.privacypolicies.com/live/7a458d57-3700-4657-846d-c0e258b2d77f")
                    }
                )
                
                SettingsCardView(
                    icon: "shield.fill",
                    title: "Privacy Policy",
                    subtitle: "Data protection",
                    color: AppTheme.lightBlue,
                    action: {
                        openURL("https://www.privacypolicies.com/live/4059940b-e49a-439a-a6b5-97bdfbbf64de")
                    }
                )
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsCardView: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(AppTheme.primaryWhite)
                    .frame(width: 60, height: 60)
                    .background(
                        Circle()
                            .fill(color)
                            .shadow(color: AppTheme.shadowColor, radius: 8, x: 0, y: 4)
                    )
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.appBodyBold)
                        .foregroundColor(AppTheme.primaryWhite)
                        .multilineTextAlignment(.center)
                    
                    Text(subtitle)
                        .font(.appCaption)
                        .foregroundColor(AppTheme.primaryWhite.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppTheme.primaryWhite.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray, lineWidth: 1)
                    )
            )
        }
    }
}

struct SettingsRowView: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppTheme.primaryYellow)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(AppTheme.primaryYellow.opacity(0.2))
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.appBodyBold)
                        .foregroundColor(AppTheme.primaryWhite)
                    
                    Text(subtitle)
                        .font(.appCaption)
                        .foregroundColor(AppTheme.primaryWhite.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppTheme.primaryWhite.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AppInfoSection: View {
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Image(systemName: "leaf.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(AppTheme.primaryYellow)
                
                Text("NutriyaPlan")
                    .font(.appLargeTitle)
                    .foregroundColor(AppTheme.primaryWhite)
                
                Text("Keep your plants nourished")
                    .font(.appSubheadline)
                    .foregroundColor(AppTheme.primaryWhite.opacity(0.8))
                    .italic()
            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppTheme.primaryWhite.opacity(0.1))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray, lineWidth: 1)
                    }
            )
        }
    }
}

