import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    selectedTab = tab
                }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                .fill(AppTheme.Colors.cardBackground.opacity(0.95))
                .shadow(color: AppTheme.Shadows.card, radius: 8, x: 0, y: -2)
        )
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.bottom, AppTheme.Spacing.sm)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppTheme.Spacing.xs) {
                Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? AppTheme.Colors.accent : AppTheme.Colors.secondaryText)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.title)
                    .font(.playfairDisplay(AppTheme.Typography.caption1, weight: .medium))
                    .foregroundColor(isSelected ? AppTheme.Colors.accent : AppTheme.Colors.secondaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.xs)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                    .fill(isSelected ? AppTheme.Colors.accent.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

enum TabItem: CaseIterable {
    case quotes
    case themes
    case filters
    case search
    case settings
    
    var title: String {
        switch self {
        case .quotes:
            return "Quotes"
        case .themes:
            return "Themes"
        case .filters:
            return "Filters"
        case .search:
            return "Search"
        case .settings:
            return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .quotes:
            return "quote.bubble"
        case .themes:
            return "folder"
        case .filters:
            return "line.3.horizontal.decrease"
        case .search:
            return "magnifyingglass"
        case .settings:
            return "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .quotes:
            return "quote.bubble.fill"
        case .themes:
            return "folder.fill"
        case .filters:
            return "line.3.horizontal.decrease.circle.fill"
        case .search:
            return "magnifyingglass.circle.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.quotes))
    }
    .primaryBackground()
}
