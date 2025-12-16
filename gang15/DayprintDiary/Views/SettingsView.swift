import SwiftUI
import StoreKit

struct SettingsView: View {
    @State private var showingRateApp = false
    
    private let settingsItems = [
        SettingsSection(
            title: "Legal",
            items: [
                SettingsItem(title: "Terms and Conditions", icon: "doc.text", action: .openURL),
                SettingsItem(title: "Privacy Policy", icon: "hand.raised", action: .openURL),
                SettingsItem(title: "Contact Us", icon: "envelope", action: .openURL)
            ]
        ),
        SettingsSection(
            title: "Support",
            items: [
                SettingsItem(title: "Rate App", icon: "star", action: .rateApp)
            ]
        )
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AppTheme.Colors.background
                    .ignoresSafeArea()
                
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(AppTheme.Colors.orb1)
                        .frame(width: 25 + CGFloat(index * 10))
                        .position(orbPosition(for: index, in: geometry))
                        .animation(
                            Animation.easeInOut(duration: 6 + Double(index))
                                .repeatForever(autoreverses: true),
                            value: UUID()
                        )
                }
                
                ScrollView {
                    VStack(spacing: AppTheme.Spacing.xl) {
                        headerView
                        
                        appInfoView
                        
                        ForEach(settingsItems.indices, id: \.self) { sectionIndex in
                            settingsSectionView(settingsItems[sectionIndex])
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, AppTheme.Spacing.lg)
                    .padding(.top, AppTheme.Spacing.lg)
                }
            }
        }
    }
    
    
    private var headerView: some View {
        HStack {
            Text("Settings")
                .font(AppTheme.Typography.largeTitle)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            Spacer()
        }
    }
    
    
    private var appInfoView: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg)
                .fill(AppTheme.Colors.primaryPurple)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "book.fill")
                        .font(.system(size: 40, weight: .medium))
                        .foregroundColor(AppTheme.Colors.primaryText)
                )
            
            VStack(spacing: AppTheme.Spacing.sm) {
                Text("Memory Helper")
                    .font(AppTheme.Typography.title2)
                    .foregroundColor(AppTheme.Colors.primaryText)
            }
        }
        .padding(.top, AppTheme.Spacing.lg)
    }
    
    private func settingsSectionView(_ section: SettingsSection) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            HStack {
                Text(section.title)
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Spacer()
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            
            VStack(spacing: 1) {
                ForEach(section.items.indices, id: \.self) { itemIndex in
                    settingsItemView(section.items[itemIndex], isLast: itemIndex == section.items.count - 1)
                }
            }
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.lg)
        }
    }
    
    @ViewBuilder
    private func settingsItemView(_ item: SettingsItem, isLast: Bool) -> some View {
        Button(action: {
            handleItemAction(item.action)
        }) {
            HStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: item.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppTheme.Colors.accent)
                    .frame(width: 24, height: 24)
                
                Text(item.title)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppTheme.Colors.tertiaryText)
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(Color.clear)
        }
        
        if !isLast {
            Divider()
                .background(AppTheme.Colors.tertiaryText.opacity(0.3))
                .padding(.leading, AppTheme.Spacing.lg + 24 + AppTheme.Spacing.md)
        }
    }
    
    private func handleItemAction(_ action: SettingsAction) {
        switch action {
        case .openURL:
            if let url = URL(string: "https://www.google.com") {
                UIApplication.shared.open(url)
            }
        case .rateApp:
            requestAppReview()
        }
    }
    
    private func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func orbPosition(for index: Int, in geometry: GeometryProxy) -> CGPoint {
        let width = geometry.size.width
        let height = geometry.size.height
        
        let positions: [CGPoint] = [
            CGPoint(x: width * 0.15, y: height * 0.2),
            CGPoint(x: width * 0.85, y: height * 0.4),
            CGPoint(x: width * 0.3, y: height * 0.8)
        ]
        
        return positions[index % positions.count]
    }
}

struct SettingsSection {
    let title: String
    let items: [SettingsItem]
}

struct SettingsItem {
    let title: String
    let icon: String
    let action: SettingsAction
}

enum SettingsAction {
    case openURL
    case rateApp
}

#Preview {
    SettingsView()
}
