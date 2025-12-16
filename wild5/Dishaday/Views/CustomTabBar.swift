import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = TabItem.allTabs
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                TabBarButton(
                    tab: tabs[index],
                    isSelected: selectedTab == index
                ) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = index
                    }
                }
            }
        }
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.cardBorder, lineWidth: 1)
                )
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
            VStack(spacing: 6) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(Color.primaryYellow)
                            .frame(width: 40, height: 40)
                            .shadow(color: Color.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    
                    Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? .buttonText : .textSecondary)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                
                Text(tab.title)
                    .font(.playfairSmall(11))
                    .foregroundColor(isSelected ? .textPrimary : .textTertiary)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
}

struct TabItem {
    let title: String
    let icon: String
    let selectedIcon: String
    
    static let allTabs = [
        TabItem(title: "Catalog", icon: "square.grid.2x2", selectedIcon: "square.grid.2x2.fill"),
        TabItem(title: "Categories", icon: "tag", selectedIcon: "tag.fill"),
        TabItem(title: "Stories", icon: "book", selectedIcon: "book.fill"),
        TabItem(title: "Statistics", icon: "chart.bar", selectedIcon: "chart.bar.fill"),
        TabItem(title: "Settings", icon: "gearshape", selectedIcon: "gearshape.fill")
    ]
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(0))
    }
    .background(
        LinearGradient(
            colors: [Color.backgroundGradientStart, Color.backgroundGradientEnd],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
}
