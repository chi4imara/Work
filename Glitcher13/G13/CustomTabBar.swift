import SwiftUI

enum TabItem: String, CaseIterable {
    case experiments = "Experiments"
    case categories = "Categories"
    case favorites = "Favorites"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var iconName: String {
        switch self {
        case .experiments:
            return "flask"
        case .categories:
            return "square.grid.2x2"
        case .favorites:
            return "heart"
        case .statistics:
            return "chart.bar"
        case .settings:
            return "gearshape"
        }
    }
    
    var selectedIconName: String {
        switch self {
        case .experiments:
            return "flask.fill"
        case .categories:
            return "square.grid.2x2.fill"
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
                    selectedTab: $selectedTab
                )
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(AppColors.tabBarGradient)
                .shadow(color: AppColors.mediumGray.opacity(0.3), radius: 12, x: 0, y: 4)
                .shadow(color: AppColors.mediumGray.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

struct TabBarButton: View {
    let tab: TabItem
    @Binding var selectedTab: TabItem
    
    private var isSelected: Bool {
        selectedTab == tab
    }
    
    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? tab.selectedIconName : tab.iconName)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isSelected ? AppColors.yellow : AppColors.mediumGray)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.rawValue)
                    .font(.playfair(10, weight: .semibold))
                    .foregroundColor(isSelected ? AppColors.yellow : AppColors.mediumGray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(isSelected ? AppColors.yellow.opacity(0.2) : Color.clear)
            )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.experiments))
}
