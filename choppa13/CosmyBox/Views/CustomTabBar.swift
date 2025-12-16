import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        TabItem(icon: "bag.fill", title: "Bags", index: 0),
        TabItem(icon: "list.clipboard.fill", title: "Products", index: 1),
        TabItem(icon: "plus.circle.fill", title: "Add", index: 2),
        TabItem(icon: "magnifyingglass", title: "Search", index: 3),
        TabItem(icon: "gearshape.fill", title: "Settings", index: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.index) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab.index,
                    action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = tab.index
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.primaryWhite.opacity(0.95))
                .shadow(color: Color.theme.primaryPurple.opacity(0.2), radius: 10, x: 0, y: -5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabItem {
    let icon: String
    let title: String
    let index: Int
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
                            .fill(Color.theme.primaryPurple)
                            .frame(width: 40, height: 40)
                            .scaleEffect(isSelected ? 1.0 : 0.8)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: tab.index == 2 ? 24 : 20, weight: .medium))
                        .foregroundColor(isSelected ? Color.theme.primaryWhite : Color.theme.darkGray)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                .animation(.easeInOut(duration: 0.2), value: isSelected)
                
                Text(tab.title)
                    .font(.ubuntu(10, weight: .medium))
                    .foregroundColor(isSelected ? Color.theme.primaryPurple : Color.theme.darkGray)
                    .opacity(isSelected ? 1.0 : 0.7)
            }
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(0))
    }
    .background(Color.theme.backgroundGradient)
}
