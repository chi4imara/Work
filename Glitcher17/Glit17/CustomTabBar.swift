import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        TabItem(title: "Schedule", icon: "calendar", tag: 0),
        TabItem(title: "Categories", icon: "folder", tag: 1),
        TabItem(title: "History", icon: "clock", tag: 2),
        TabItem(title: "Statistics", icon: "chart.bar", tag: 3),
        TabItem(title: "Settings", icon: "gearshape", tag: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.tag) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab.tag
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab.tag
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(ColorManager.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(ColorManager.textWhite.opacity(0.1), lineWidth: 1)
                )
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
                Image(systemName: tab.icon)
                    .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? ColorManager.accentYellow : ColorManager.textSecondary)
                
                Text(tab.title)
                    .font(FontManager.ubuntu(10, weight: isSelected ? .medium : .regular))
                    .foregroundColor(isSelected ? ColorManager.accentYellow : ColorManager.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? ColorManager.accentYellow.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ZStack {
        ColorManager.mainGradient
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            CustomTabBar(selectedTab: .constant(0))
        }
    }
}
