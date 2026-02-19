import SwiftUI

enum TabItem: String, CaseIterable {
    case week = "Week"
    case categories = "Categories"
    case history = "History"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .week:
            return "calendar"
        case .categories:
            return "list.bullet.rectangle"
        case .history:
            return "clock"
        case .statistics:
            return "chart.bar"
        case .settings:
            return "gearshape"
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
        .padding(.horizontal, 10)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(ColorManager.cardGradient)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
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
                Image(systemName: tab.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? ColorManager.lightBlue : ColorManager.secondaryText)
                
                Text(tab.rawValue)
                    .font(.ubuntu(10, weight: .medium))
                    .foregroundColor(isSelected ? ColorManager.lightBlue : ColorManager.secondaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? ColorManager.lightBlue.opacity(0.2) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.week))
    }
    .background(ColorManager.backgroundGradient)
}
