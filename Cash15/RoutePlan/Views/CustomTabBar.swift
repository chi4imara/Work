import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(title: "Travels", icon: "globe", tag: 0),
        TabItem(title: "Calendar", icon: "calendar", tag: 1),
        TabItem(title: "Wishlist", icon: "heart", tag: 2),
        TabItem(title: "Stats", icon: "chart.bar", tag: 3),
        TabItem(title: "Settings", icon: "gearshape", tag: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.tag) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab.tag
                ) {
                    selectedTab = tab.tag
                }
            }
        }
        .frame(height: 80)
        .padding(.bottom, 12)
        .background(
            ColorTheme.tabBarBackground
                .ignoresSafeArea(edges: .bottom)
        )
        .overlay(
            Rectangle()
                .fill(ColorTheme.borderColor)
                .frame(height: 0.5),
            alignment: .top
        )
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
                    .foregroundColor(isSelected ? ColorTheme.tabBarSelected : ColorTheme.tabBarUnselected)
                
                Text(tab.title)
                    .font(FontManager.small)
                    .foregroundColor(isSelected ? ColorTheme.tabBarSelected : ColorTheme.tabBarUnselected)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .contentShape(Rectangle())
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
    CustomTabBar(selectedTab: .constant(0))
}

