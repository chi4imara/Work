import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        TabItem(icon: "tshirt", title: "Wardrobe", index: 0),
        TabItem(icon: "list.bullet.clipboard", title: "Shopping", index: 1),
        TabItem(icon: "note.text", title: "Notes", index: 2),
        TabItem(icon: "chart.bar", title: "Statistics", index: 3),
        TabItem(icon: "gearshape", title: "Settings", index: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.index) { tab in
                TabBarButton(
                    icon: tab.icon,
                    title: tab.title,
                    isSelected: selectedTab == tab.index
                ) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = tab.index
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.cardBackground)
                .shadow(color: AppShadows.cardShadow, radius: 8, x: 0, y: -2)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: isSelected ? 22 : 18, weight: .medium))
                    .foregroundColor(isSelected ? Color.primaryPurple : Color.textSecondary)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(title)
                    .font(FontManager.playfairDisplay(size: isSelected ? 12 : 10, weight: .medium))
                    .foregroundColor(isSelected ? Color.primaryPurple : Color.textSecondary)
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? Color.primaryYellow.opacity(0.2) : Color.clear)
                    .scaleEffect(isSelected ? 1.0 : 0.8)
            )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct TabItem {
    let icon: String
    let title: String
    let index: Int
}
