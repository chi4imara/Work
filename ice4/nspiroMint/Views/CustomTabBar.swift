import SwiftUI

enum TabItem: String, CaseIterable {
    case today = "Today"
    case favorites = "Favorites"
    case history = "History"
    case categories = "Categories"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .today:
            return "sun.max"
        case .favorites:
            return "heart"
        case .history:
            return "clock"
        case .categories:
            return "folder"
        case .settings:
            return "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .today:
            return "sun.max.fill"
        case .favorites:
            return "heart.fill"
        case .history:
            return "clock.fill"
        case .categories:
            return "folder.fill"
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
                .fill(AppColors.cardGradient)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
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
                    .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? AppColors.primaryYellow : AppColors.primaryWhite.opacity(0.7))
                
                Text(tab.rawValue)
                    .font(.playfairDisplay(10, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? AppColors.primaryYellow : AppColors.primaryWhite.opacity(0.7))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? AppColors.primaryWhite.opacity(0.2) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.today))
    }
    .background(AppColors.backgroundGradient)
}
