import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @Namespace private var tabBarNamespace
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    selectedTab: $selectedTab,
                    namespace: tabBarNamespace
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.tabBarBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    @Binding var selectedTab: TabItem
    let namespace: Namespace.ID
    
    private var isSelected: Bool {
        selectedTab == tab
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                selectedTab = tab
            }
        }) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.tabBarSelected)
                            .frame(width: 40, height: 40)
                            .matchedGeometryEffect(id: "selectedTab", in: namespace)
                    }
                    
                    Image(systemName: tab.iconName)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? AppColors.buttonText : AppColors.tabBarUnselected)
                }
                
                Text(tab.title)
                    .font(.ubuntu(10, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.tabBarSelected : AppColors.tabBarUnselected)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.catalog))
    }
    .background(AnimatedBackground())
}