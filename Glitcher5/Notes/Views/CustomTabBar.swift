import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabItems = [
        TabItem(title: "Recipe", icon: "plus.circle", selectedIcon: "plus.circle.fill"),
        TabItem(title: "List", icon: "list.bullet", selectedIcon: "list.bullet"),
        TabItem(title: "Meat Types", icon: "square.grid.2x2", selectedIcon: "square.grid.2x2.fill"),
        TabItem(title: "Favorites", icon: "heart", selectedIcon: "heart.fill"),
        TabItem(title: "Settings", icon: "gearshape", selectedIcon: "gearshape.fill")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabItems.count, id: \.self) { index in
                TabBarButton(
                    tabItem: tabItems[index],
                    isSelected: selectedTab == index,
                    action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = index
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(ColorManager.secondaryBackground)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabItem {
    let title: String
    let icon: String
    let selectedIcon: String
}

struct TabBarButton: View {
    let tabItem: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? tabItem.selectedIcon : tabItem.icon)
                    .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? ColorManager.orange : ColorManager.secondaryText)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tabItem.title)
                    .font(.playfairDisplay(size: 10, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? ColorManager.orange : ColorManager.secondaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? ColorManager.orange.opacity(0.1) : Color.clear)
            )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    ZStack {
        ColorManager.primaryBackground
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            CustomTabBar(selectedTab: .constant(0))
        }
    }
}
