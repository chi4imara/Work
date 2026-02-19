import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        TabItem(icon: "square.grid.2x2", title: "Collection", tag: 0),
        TabItem(icon: "paintbrush", title: "Styles", tag: 1),
        TabItem(icon: "heart", title: "Favorites", tag: 2),
        TabItem(icon: "chart.bar", title: "Statistics", tag: 3),
        TabItem(icon: "gear", title: "Settings", tag: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.tag) { tab in
                TabBarButton(
                    icon: tab.icon,
                    title: tab.title,
                    isSelected: selectedTab == tab.tag,
                    action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = tab.tag
                        }
                    }
                )
            }
        }
        .padding(.vertical, 12)
        .cornerRadius(12)
        .background(ColorTheme.cardGradient)
        .cornerRadius(12)
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
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isSelected ? ColorTheme.lightBlue : ColorTheme.secondaryText)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(title)
                    .font(.playfairDisplay(10, weight: .semibold))
                    .foregroundColor(isSelected ? ColorTheme.lightBlue : ColorTheme.secondaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                isSelected ?
                ColorTheme.lightBlue.opacity(0.1) :
                    Color.clear
            )
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TabItem {
    let icon: String
    let title: String
    let tag: Int
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(0))
    }
    .background(ColorTheme.backgroundGradient)
}
