import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(
                icon: "lightbulb.fill",
                title: "Ideas",
                isSelected: selectedTab == 0,
                action: { selectedTab = 0 }
            )
            
            TabBarButton(
                icon: "magnifyingglass",
                title: "Search",
                isSelected: selectedTab == 1,
                action: { selectedTab = 1 }
            )
            
            TabBarButton(
                icon: "plus.circle.fill",
                title: "Add",
                isSelected: selectedTab == 2,
                action: { selectedTab = 2 }
            )
            
            TabBarButton(
                icon: "heart.fill",
                title: "Favorites",
                isSelected: selectedTab == 3,
                action: { selectedTab = 3 }
            )
            
            TabBarButton(
                icon: "gearshape.fill",
                title: "Settings",
                isSelected: selectedTab == 4,
                action: { selectedTab = 4 }
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(AppColors.primaryText.opacity(0.1), lineWidth: 1)
                )
        )
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
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.accentYellow : AppColors.primaryText.opacity(0.6))
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(title)
                    .font(.ubuntu(10, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.accentYellow : AppColors.primaryText.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
