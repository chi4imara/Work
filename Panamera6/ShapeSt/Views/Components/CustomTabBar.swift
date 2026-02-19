import SwiftUI

enum TabItem: String, CaseIterable {
    case catalog = "Catalog"
    case categories = "Categories"
    case favorites = "Favorites"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .catalog:
            return "list.bullet"
        case .categories:
            return "folder"
        case .favorites:
            return "heart"
        case .statistics:
            return "chart.bar"
        case .settings:
            return "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .catalog:
            return "list.bullet"
        case .categories:
            return "folder.fill"
        case .favorites:
            return "heart.fill"
        case .statistics:
            return "chart.bar.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
}

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
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(ColorTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(ColorTheme.white.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? ColorTheme.orange : ColorTheme.white.opacity(0.6))
                
                Text(tab.rawValue)
                    .font(.lumierepolis(size: 10))
                    .foregroundColor(isSelected ? ColorTheme.orange : ColorTheme.white.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? ColorTheme.orange.opacity(0.2) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
