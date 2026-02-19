import SwiftUI

enum TabItem: String, CaseIterable {
    case tests = "Tests"
    case categories = "Categories"
    case filters = "Filters"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .tests:
            return "list.bullet.clipboard"
        case .categories:
            return "square.grid.2x2"
        case .filters:
            return "line.3.horizontal.decrease.circle"
        case .statistics:
            return "chart.bar.fill"
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
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.cardBackground)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -2)
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
                    .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? AppColors.yellow : AppColors.primaryText.opacity(0.6))
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.rawValue)
                    .font(.playfairDisplay(10, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? AppColors.yellow : AppColors.primaryText.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? AppColors.yellow.opacity(0.2) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.tests))
    }
    .background(BackgroundView())
}
