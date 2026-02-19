import SwiftUI

enum TabItem: String, CaseIterable {
    case catalog = "Catalog"
    case favorites = "Favorites"
    case filters = "Filters"
    case add = "Add"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .catalog:
            return "square.grid.2x2"
        case .favorites:
            return "heart"
        case .filters:
            return "line.3.horizontal.decrease"
        case .add:
            return "plus.circle"
        case .settings:
            return "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .catalog:
            return "square.grid.2x2.fill"
        case .favorites:
            return "heart.fill"
        case .filters:
            return "line.3.horizontal.decrease.circle.fill"
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
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(AppColors.tabBarBackground)
                
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
                
                RoundedRectangle(cornerRadius: 25)
                    .stroke(AppColors.tabBarBorder, lineWidth: 1.5)
            }
        )
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -2)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
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
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(AppColors.primaryYellow)
                            .frame(width: 40, height: 40)
                            .scaleEffect(isSelected ? 1.0 : 0.8)
                    }
                    
                    Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                        .font(.system(size: isSelected ? 20 : 18, weight: .medium))
                        .foregroundColor(isSelected ? AppColors.backgroundGradientStart : Color.blue)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                
                Text(tab.rawValue)
                    .font(.ubuntu(10, weight: isSelected ? .medium : .regular))
                    .foregroundColor(isSelected ? AppColors.primaryYellow : Color.blue)
                    .scaleEffect(isSelected ? 1.0 : 0.9)
            }
            .frame(maxWidth: .infinity)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ZStack {
        BackgroundView()
        
        VStack {
            Spacer()
            CustomTabBar(selectedTab: .constant(.catalog))
        }
    }
}
