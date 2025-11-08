import SwiftUI

enum TabItem: String, CaseIterable {
    case feed = "Feed"
    case categories = "Categories"
    case statistics = "Statistics"
    case archive = "Archive"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .feed:
            return "list.bullet"
        case .categories:
            return "folder"
        case .statistics:
            return "chart.bar"
        case .archive:
            return "archivebox"
        case .settings:
            return "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .feed:
            return "list.bullet.circle.fill"
        case .categories:
            return "folder.fill"
        case .statistics:
            return "chart.bar.fill"
        case .archive:
            return "archivebox.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    withAnimation(DesignSystem.Animation.quick) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.md)
        .padding(.vertical, DesignSystem.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.xl)
                .fill(DesignSystem.Colors.tabBarBackground)
                .shadow(
                    color: DesignSystem.Shadow.medium,
                    radius: 8,
                    x: 0,
                    y: -2
                )
        )
        .padding(.horizontal, DesignSystem.Spacing.md)
        .padding(.bottom, DesignSystem.Spacing.sm)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: DesignSystem.Spacing.xs) {
                Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                    .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? DesignSystem.Colors.tabBarSelected : DesignSystem.Colors.tabBarUnselected)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.rawValue)
                    .font(FontManager.poppinsRegular(size: 9))
                    .foregroundColor(isSelected ? DesignSystem.Colors.tabBarSelected : DesignSystem.Colors.tabBarUnselected)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignSystem.Spacing.xs)
            .background(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.md)
                    .fill(isSelected ? DesignSystem.Colors.primaryBlue.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(DesignSystem.Animation.quick, value: isSelected)
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.feed))
    }
    .backgroundGradient()
}
