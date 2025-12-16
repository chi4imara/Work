import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @State private var animateSelection = false
    
    let tabs = [
        TabItem(title: "List", icon: "list.bullet", tag: 0),
        TabItem(title: "Add", icon: "plus.circle", tag: 1),
        TabItem(title: "Categories", icon: "folder", tag: 2),
        TabItem(title: "Tips", icon: "lightbulb", tag: 3),
        TabItem(title: "Profile", icon: "person.circle", tag: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.tag) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab.tag,
                    action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = tab.tag
                            animateSelection.toggle()
                        }
                    }
                )
            }
        }
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(ColorManager.primaryWhite.opacity(0.9))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabItem {
    let title: String
    let icon: String
    let tag: Int
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
                            .fill(ColorManager.primaryYellow)
                            .frame(width: 40, height: 40)
                            .scaleEffect(isSelected ? 1.0 : 0.8)
                            .animation(.easeInOut(duration: 0.3), value: isSelected)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? ColorManager.primaryBlue : ColorManager.primaryBlue.opacity(0.6))
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: isSelected)
                }
                
                Text(tab.title)
                    .font(FontManager.ubuntu(12))
                    .foregroundColor(isSelected ? ColorManager.primaryBlue : ColorManager.primaryBlue.opacity(0.6))
                    .fontWeight(isSelected ? .semibold : .regular)
                    .animation(.easeInOut(duration: 0.3), value: isSelected)
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
    .background(ColorManager.backgroundGradientStart)
}
