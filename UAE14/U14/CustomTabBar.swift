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
        .padding(.vertical, 12)
        .background(
            AppColors.tabBarBackground
                .blur(radius: 10)
        )
        .cornerRadius(25)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(AppColors.cardBorder, lineWidth: 1)
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
                    .font(.system(size: isSelected ? 18 : 15, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.tabBarSelected : AppColors.tabBarUnselected)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.title)
                    .font(.ubuntu(9, weight: isSelected ? .medium : .regular))
                    .foregroundColor(isSelected ? AppColors.tabBarSelected : AppColors.tabBarUnselected)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.lightBlue.opacity(0.2) : Color.clear)
            )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.diary))
    }
    .background(BackgroundView())
}
