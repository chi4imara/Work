import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(title: "My Items", icon: "house.fill", tag: 0),
        TabItem(title: "Search", icon: "magnifyingglass", tag: 1),
        TabItem(title: "Add", icon: "plus.circle.fill", tag: 2),
        TabItem(title: "Categories", icon: "square.grid.2x2", tag: 3),
        TabItem(title: "Settings", icon: "gearshape.fill", tag: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.tag) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab.tag
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab.tag
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 10, x: 0, y: -5)
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
        Button(action: {
            HapticManager.selection()
            action()
        }) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(ColorTheme.primaryYellow)
                            .frame(width: 40, height: 40)
                            .scaleEffect(isSelected ? 1.0 : 0.8)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: isSelected ? 20 : 18, weight: .medium))
                        .foregroundColor(isSelected ? ColorTheme.textPrimary : ColorTheme.textSecondary)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                
                Text(tab.title)
                    .font(.playfairDisplay(10, weight: .medium))
                    .foregroundColor(isSelected ? ColorTheme.textPrimary : ColorTheme.textSecondary)
                    .opacity(isSelected ? 1.0 : 0.7)
            }
            .frame(maxWidth: .infinity)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TabItem {
    let title: String
    let icon: String
    let tag: Int
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(0))
    }
    .background(ColorTheme.backgroundGradient)
}