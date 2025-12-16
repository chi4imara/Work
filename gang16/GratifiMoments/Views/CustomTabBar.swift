import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(title: "Home", icon: "house.fill", index: 0),
        TabItem(title: "Journal", icon: "book.fill", index: 1),
        TabItem(title: "Random", icon: "shuffle", index: 2),
        TabItem(title: "Tips", icon: "lightbulb.fill", index: 3),
        TabItem(title: "Settings", icon: "gear", index: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.index) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab.index
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab.index
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.textLight.opacity(0.2), radius: 8, x: 0, y: -2)
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
                            .fill(AppColors.primaryBlue.opacity(0.2))
                            .frame(width: 40, height: 40)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.textLight)
                }
                
                Text(tab.title)
                    .font(.builderSans(.medium, size: 10))
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.textLight)
            }
        }
        .frame(maxWidth: .infinity)
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
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
    .background(BackgroundView())
}
