import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(AppColors.cardBackground)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: -2)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(AppColors.primaryText.opacity(0.2), lineWidth: 2)
                )
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
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
                    .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? AppColors.tabBarSelected : Color.black)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.rawValue)
                    .font(.ubuntu(11, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? AppColors.tabBarSelected : AppColors.darkText.opacity(0.7))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isSelected ? AppColors.tabBarSelected.opacity(0.25) : Color.clear)
            )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.looks))
    }
    .background(AppColors.backgroundGradient)
}
