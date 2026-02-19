import SwiftUI

struct CustomTabBar: View {
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        HStack {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: appViewModel.currentTab == tab
                ) {
                    appViewModel.switchTab(to: tab)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: AppConstants.largeCornerRadius)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: AppConstants.largeCornerRadius)
                        .stroke(AppColors.separatorColor, lineWidth: 1)
                )
        )
        .padding(.horizontal, 16)
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
                            .fill(AppColors.primaryOrange)
                            .frame(width: 32, height: 32)
                    }
                    
                    Image(systemName: tab.iconName)
                        .font(.system(size: AppConstants.tabBarIconSize, weight: .medium))
                        .foregroundColor(isSelected ? AppColors.primaryText : AppColors.secondaryText)
                }
                
                Text(tab.displayName)
                    .font(.ubuntu(.medium, size: 10))
                    .foregroundColor(isSelected ? AppColors.primaryOrange : AppColors.tertiaryText)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: AppConstants.shortAnimation), value: isSelected)
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(appViewModel: AppViewModel())
    }
    .background(AppColors.backgroundGradient)
}