import SwiftUI

enum TabItem: Int, CaseIterable {
    case home = 0
    case categories = 1
    case favorites = 2
    case add = 3
    case settings = 4
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .categories:
            return "Categories"
        case .favorites:
            return "Favorites"
        case .add:
            return "Add"
        case .settings:
            return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .categories:
            return "square.grid.2x2.fill"
        case .favorites:
            return "heart.fill"
        case .add:
            return "plus.circle.fill"
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
                .fill(Color.white)
                .shadow(color: .shadowColor, radius: 8, x: 0, y: -2)
        )
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 20)
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
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isSelected ? .primaryYellow : Color.primaryBlue)
                    .scaleEffect(1.0)
                
                Text(tab.title)
                    .font(.lumierepolis(10, weight: .light))
                    .foregroundColor(isSelected ? .primaryYellow : Color.primaryBlue)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? Color.primaryYellow.opacity(0.2) : Color.clear)
            )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.home))
    }
    .background(AppColors.backgroundGradient)
}
