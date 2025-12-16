import SwiftUI

enum TabItem: String, CaseIterable {
    case today = "Today"
    case favorites = "Favorites"
    case history = "History"
    case collections = "Collections"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .today:
            return "house"
        case .favorites:
            return "heart"
        case .history:
            return "clock"
        case .collections:
            return "folder"
        case .settings:
            return "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .today:
            return "house.fill"
        case .favorites:
            return "heart.fill"
        case .history:
            return "clock.fill"
        case .collections:
            return "folder.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    selectedTab: $selectedTab
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(AppColors.primaryWhite.opacity(0.9))
        )
        .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 10, x: 0, y: -2)
    }
    
    private func offsetForSelectedTab() -> CGFloat {
        let tabWidth = UIScreen.main.bounds.width / CGFloat(TabItem.allCases.count)
        let selectedIndex = TabItem.allCases.firstIndex(of: selectedTab) ?? 0
        let totalWidth = UIScreen.main.bounds.width - 32 
        let buttonWidth = totalWidth / CGFloat(TabItem.allCases.count)
        
        return CGFloat(selectedIndex) * buttonWidth - (totalWidth / 2) + (buttonWidth / 2)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    @Binding var selectedTab: TabItem
    @State private var isPressed = false
    
    var isSelected: Bool {
        selectedTab == tab
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        }) {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                    .font(.system(size: 20, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.darkGray.opacity(0.6))
                    .scaleEffect(isPressed ? 0.9 : 1.0)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.rawValue)
                    .font(.playfairDisplay(size: 10, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.darkGray.opacity(0.6))
                    .opacity(isSelected ? 1.0 : 0.7)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.today))
            .padding()
    }
    .background(AppColors.backgroundGradient)
}
