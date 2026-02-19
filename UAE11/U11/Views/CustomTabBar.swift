import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(title: "Home", icon: "house.fill", index: 0),
        TabItem(title: "Progress", icon: "chart.line.uptrend.xyaxis", index: 1),
        TabItem(title: "Statistics", icon: "chart.bar.fill", index: 2),
        TabItem(title: "Achievements", icon: "trophy.fill", index: 3),
        TabItem(title: "Settings", icon: "gearshape.fill", index: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.index) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab.index,
                    action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = tab.index
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.cardGradient)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
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
                Image(systemName: tab.icon)
                    .font(.system(size: isSelected ? 20 : 18, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.lightBlue : AppColors.primaryText.opacity(0.6))
                
                Text(tab.title)
                    .font(.playfairDisplay(size: 8, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.lightBlue : AppColors.primaryText.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? AppColors.lightBlue.opacity(0.2) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TabItem {
    let title: String
    let icon: String
    let index: Int
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(0))
    }
    .background(AppColors.primaryGradient)
}
