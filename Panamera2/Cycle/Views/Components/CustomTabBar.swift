import SwiftUI

enum TabItem: CaseIterable {
    case jewelry
    case categories
    case recent
    case statistics
    case settings
    
    var title: String {
        switch self {
        case .jewelry: return "Jewelry"
        case .categories: return "Categories"
        case .recent: return "Recent"
        case .statistics: return "Statistics"
        case .settings: return "Settings"
        }
    }
    
    var iconName: String {
        switch self {
        case .jewelry: return "sparkles"
        case .categories: return "square.grid.2x2"
        case .recent: return "clock"
        case .statistics: return "chart.bar"
        case .settings: return "gearshape"
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
                .fill(AppColors.cardBackground)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
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
                Image(systemName: tab.iconName)
                    .font(.system(size: 18, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? AppColors.accentYellow : AppColors.darkGray)
                
                Text(tab.title)
                    .font(.bauhausLight(size: 10))
                    .foregroundColor(isSelected ? AppColors.accentYellow : AppColors.darkGray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? AppColors.accentYellow.opacity(0.2) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.jewelry))
}
