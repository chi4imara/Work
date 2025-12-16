import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        TabItem(icon: "star.fill", title: "Inspirations", index: 0),
        TabItem(icon: "quote.bubble.fill", title: "Quotes", index: 1),
        TabItem(icon: "note.text", title: "Notes", index: 2),
        TabItem(icon: "plus.circle.fill", title: "Add", index: 3),
        TabItem(icon: "gearshape.fill", title: "Settings", index: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.index) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab.index
                ) {
                    selectedTab = tab.index
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.theme.tabBarBackground)
                
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
                
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.theme.primaryText.opacity(0.3), lineWidth: 1.5)
            }
        )
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -2)
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
                    .font(.system(size: isSelected ? 20 : 18, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? Color.theme.tabBarSelected : Color.theme.tabBarUnselected)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.title)
                    .font(FontManager.ubuntu(isSelected ? 10 : 10, weight: isSelected ? .medium : .medium))
                    .foregroundColor(isSelected ? Color.theme.tabBarSelected : Color.theme.tabBarUnselected)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? Color.theme.primaryYellow.opacity(0.3) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct TabItem {
    let icon: String
    let title: String
    let index: Int
}

#Preview {
    ZStack {
        Color.theme.backgroundGradient
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            CustomTabBar(selectedTab: .constant(0))
        }
    }
}
