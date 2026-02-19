import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(icon: "calendar", title: "Care Plan", tag: 0),
        TabItem(icon: "book", title: "Skin Diary", tag: 1),
        TabItem(icon: "clock", title: "History", tag: 2),
        TabItem(icon: "chart.bar", title: "Statistics", tag: 3),
        TabItem(icon: "gearshape", title: "Settings", tag: 4)
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
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(ColorManager.tabBarBackground)
                .shadow(color: ColorManager.shadowColor, radius: 10, x: 0, y: -2)
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
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [ColorManager.primaryBlue, ColorManager.primaryYellow]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)
                            .transition(.scale.combined(with: .opacity))
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? .white : ColorManager.tabBarUnselected)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                .animation(.easeInOut(duration: 0.3), value: isSelected)
                
                Text(tab.title)
                    .font(.caption)
                    .foregroundColor(isSelected ? ColorManager.tabBarSelected : ColorManager.tabBarUnselected)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .animation(.easeInOut(duration: 0.3), value: isSelected)
            }
            .frame(maxWidth: .infinity)
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
    .background(ColorManager.backgroundGradient)
}
