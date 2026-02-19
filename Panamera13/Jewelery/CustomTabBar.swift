import SwiftUI

enum TabItem: String, CaseIterable {
    case jewelry = "Jewelry"
    case sets = "Sets"
    case favorites = "Favorites"
    case search = "Statistics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .jewelry:
            return "sparkles"
        case .sets:
            return "square.stack.3d.up"
        case .favorites:
            return "heart"
        case .search:
            return "chart.bar"
        case .settings:
            return "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .jewelry:
            return "sparkles"
        case .sets:
            return "square.stack.3d.up.fill"
        case .favorites:
            return "heart.fill"
        case .search:
            return "chart.bar.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @State private var tabItemWidth: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarItem(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = tab
                        }
                    }
                )
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(ColorTheme.cardBorder)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarItem: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(ColorTheme.accentYellow.opacity(0.2))
                            .frame(width: 40, height: 40)
                            .scaleEffect(isPressed ? 0.9 : 1.0)
                    }
                    
                    Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                        .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                        .foregroundColor(isSelected ? ColorTheme.accentYellow : ColorTheme.secondaryText)
                        .scaleEffect(isPressed ? 0.8 : 1.0)
                }
                
                Text(tab.rawValue)
                    .font(.lumierepolis(10, weight: isSelected ? .bold : .regular))
                    .foregroundColor(isSelected ? ColorTheme.accentYellow : ColorTheme.secondaryText)
                    .scaleEffect(isPressed ? 0.9 : 1.0)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.jewelry))
    }
    .background(ColorTheme.backgroundGradient)
}
