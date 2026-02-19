import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(title: "Wardrobe", icon: "tshirt.fill", tag: 0),
        TabItem(title: "Outfits", icon: "heart.fill", tag: 1),
        TabItem(title: "Statistics", icon: "chart.bar.fill", tag: 2),
        TabItem(title: "History", icon: "calendar", tag: 3),
        TabItem(title: "Settings", icon: "gearshape.fill", tag: 4)
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
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(color: AppColors.shadow, radius: 10, x: 0, y: -2)
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
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.textSecondary)
                
                Text(tab.title)
                    .font(.ubuntu(12, weight: isSelected ? .medium : .regular))
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? AppColors.primary.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(0))
    }
    .background(AppColors.gradient)
}