import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) private var requestReview
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 24) {
                        appSectionView
                        
                        legalSectionView
                        
                        contactSectionView
                        
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
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var appSectionView: some View {
        SettingsSectionView(title: "App", icon: "app.badge") {
            VStack(spacing: 0) {
                SettingsRowView(
                    title: "Rate the App",
                    icon: "star.fill",
                    iconColor: AppColors.primaryYellow
                ) {
                    requestReview()
                }
            }
        }
    }
    
    private var legalSectionView: some View {
        SettingsSectionView(title: "Legal", icon: "doc.text") {
            VStack(spacing: 0) {
                SettingsRowView(
                    title: "Terms of Use",
                    icon: "doc.plaintext",
                    iconColor: AppColors.accentOrange
                ) {
                    openURL("https://docs.google.com/document/d/1FjIuCPyBz5PMfVkwAzuvzgE4lhS8FiIZ_XCY1hhT2KI/edit?usp=sharing")
                }
                
                SettingsRowView(
                    title: "Privacy Policy",
                    icon: "hand.raised",
                    iconColor: AppColors.accentGreen
                ) {
                    openURL("https://docs.google.com/document/d/1Udb4HNEcpGTYbTeL4w0eKg4Z-AWXHBlgLTrUaPughaY/edit?usp=sharing")
                }
            }
        }
    }
    
    private var contactSectionView: some View {
        SettingsSectionView(title: "Contact", icon: "envelope") {
            VStack(spacing: 0) {
                SettingsRowView(
                    title: "Contact Us",
                    icon: "envelope.fill",
                    iconColor: AppColors.primaryBlue,

                ) {
                    openURL("https://forms.gle/QGkZfcWViR2FMBLBA")
                }
            }
        }
    }
    
    private func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsSectionView<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColors.primaryYellow)
                
                Text(title)
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
            
            Divider()
                .overlay {
                    Color.white
                }
                .padding(.horizontal, -20)
            
            content
        }
        .padding(20)
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct SettingsRowView: View {
    let title: String
    let icon: String
    let iconColor: Color
    let subtitle: String?
    let action: () -> Void
    
    init(title: String, icon: String, iconColor: Color, subtitle: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.iconColor = iconColor
        self.subtitle = subtitle
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
                
                if subtitle == nil || !subtitle!.contains("(") {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.textTertiary)
                }
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
    }
}

struct CreativeSettingsLayout: View {
    let items: [SettingsItem]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    SettingsFloatingButton(item: item)
                        .position(getPosition(for: index, in: geometry.size))
                }
            }
        }
    }
    
    private func getPosition(for index: Int, in size: CGSize) -> CGPoint {
        let positions: [CGPoint] = [
            CGPoint(x: size.width * 0.2, y: size.height * 0.3),
            CGPoint(x: size.width * 0.8, y: size.height * 0.2),
            CGPoint(x: size.width * 0.3, y: size.height * 0.6),
            CGPoint(x: size.width * 0.7, y: size.height * 0.7),
            CGPoint(x: size.width * 0.5, y: size.height * 0.9)
        ]
        
        return positions[min(index, positions.count - 1)]
    }
}

struct SettingsFloatingButton: View {
    let item: SettingsItem
    
    var body: some View {
        Button(action: item.action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(item.color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .stroke(item.color, lineWidth: 2)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(item.color)
                }
                
                Text(item.title)
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingsItem {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
}

#Preview {
    SettingsView()
}
