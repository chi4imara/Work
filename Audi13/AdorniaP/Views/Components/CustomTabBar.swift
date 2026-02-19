import SwiftUI

struct CustomTabBar: View {
    @ObservedObject var navigationViewModel: NavigationViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarItem(
                    tab: tab,
                    isSelected: navigationViewModel.selectedTab == tab,
                    action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            navigationViewModel.selectTab(tab)
                        }
                    }
                )
            }
        }
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.cardBackground)
                .shadow(color: Color.theme.cardShadow, radius: 15, x: 0, y: -5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarItem: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(Color.theme.primaryYellow)
                            .frame(width: 40, height: 40)
                            .scaleEffect(isSelected ? 1.0 : 0.8)
                    }
                    
                    Image(systemName: isSelected ? tab.selectedIconName : tab.iconName)
                        .font(.system(size: 20, weight: isSelected ? .semibold : .medium))
                        .foregroundColor(isSelected ? Color.theme.buttonText : Color.theme.secondaryText)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                
                Text(tab.rawValue)
                    .font(.bauhausRegular(10))
                    .foregroundColor(isSelected ? Color.theme.primaryText : Color.theme.secondaryText)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
}
