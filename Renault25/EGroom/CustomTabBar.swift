import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        TabItem(title: "Today", icon: "house", tag: 0),
        TabItem(title: "Procedures", icon: "list.bullet.clipboard", tag: 1),
        TabItem(title: "Statistics", icon: "chart.bar", tag: 2),
        TabItem(title: "History", icon: "calendar", tag: 3),
        TabItem(title: "Settings", icon: "gearshape", tag: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.tag) { tab in
                TabBarButton(
                    title: tab.title,
                    icon: tab.icon,
                    isSelected: selectedTab == tab.tag
                ) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = tab.tag
                    }
                }
            }
        }
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.cardGradient)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(Color.primaryOrange)
                            .frame(width: 40, height: 40)
                            .scaleEffect(isSelected ? 1.0 : 0.8)
                            .animation(.easeInOut(duration: 0.3), value: isSelected)
                    }
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? .primaryWhite : .primaryWhite.opacity(0.6))
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: isSelected)
                }
                
                Text(title)
                    .font(FontManager.playfairDisplay(.medium, size: 10))
                    .foregroundColor(isSelected ? .primaryOrange : .primaryWhite.opacity(0.6))
                    .animation(.easeInOut(duration: 0.3), value: isSelected)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct TabItem {
    let title: String
    let icon: String
    let tag: Int
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTab: .constant(0))
            .background(Color.backgroundGradient)
    }
}