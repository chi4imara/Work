import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(icon: "house.fill", title: "Home", index: 0),
        TabItem(icon: "plus.circle.fill", title: "Add", index: 1),
        TabItem(icon: "folder.fill", title: "Categories", index: 2),
        TabItem(icon: "chart.pie.fill", title: "Statistics", index: 3),
        TabItem(icon: "gearshape.fill", title: "Settings", index: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.index) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab.index
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab.index
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.tabBarBackground)
                .blur(radius: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
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
                    .font(.system(size: isSelected ? 24 : 20, weight: .medium))
                    .foregroundColor(isSelected ? Color.theme.tabBarSelected : Color.theme.tabBarUnselected)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.title)
                    .font(.ubuntu(10, weight: isSelected ? .medium : .regular))
                    .foregroundColor(isSelected ? Color.theme.tabBarSelected : Color.theme.tabBarUnselected)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct TabItem {
    let icon: String
    let title: String
    let index: Int
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(0))
    }
    .background(Color.theme.backgroundStart)
}
