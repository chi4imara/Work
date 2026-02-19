import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(title: "Courses", icon: "book.circle", selectedIcon: "book.circle.fill"),
        TabItem(title: "Skills", icon: "star.circle", selectedIcon: "star.circle.fill"),
        TabItem(title: "Progress", icon: "chart.line.uptrend.xyaxis.circle", selectedIcon: "chart.line.uptrend.xyaxis.circle.fill"),
        TabItem(title: "Profile", icon: "person.circle", selectedIcon: "person.circle.fill")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                TabBarButton(
                    tab: tabs[index],
                    isSelected: selectedTab == index,
                    action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = index
                        }
                    }
                )
            }
        }
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
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
                            .fill(Color.theme.primaryYellow.opacity(0.2))
                            .frame(width: 50, height: 50)
                            .scaleEffect(isSelected ? 1.0 : 0.8)
                            .animation(.easeInOut(duration: 0.3), value: isSelected)
                    }
                    
                    Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(isSelected ? Color.theme.primaryBlue : Color.theme.darkGray.opacity(0.6))
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: isSelected)
                }
                
                Text(tab.title)
                    .font(.custom("PlayfairDisplay-Medium", size: 12))
                    .foregroundColor(isSelected ? Color.theme.primaryBlue : Color.theme.darkGray.opacity(0.6))
                    .scaleEffect(isSelected ? 1.0 : 0.9)
                    .animation(.easeInOut(duration: 0.3), value: isSelected)
            }
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}

struct TabItem {
    let title: String
    let icon: String
    let selectedIcon: String
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(0))
    }
    .background(Color.gray.opacity(0.1))
}