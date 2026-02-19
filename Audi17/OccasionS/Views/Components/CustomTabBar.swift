import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(title: "Archive", icon: "archivebox", tag: 0),
        TabItem(title: "Selection", icon: "wand.and.stars", tag: 1),
        TabItem(title: "Filters", icon: "slider.horizontal.3", tag: 2),
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
                .fill(AppColors.cardBackground)
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
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? AppColors.primaryWhite : AppColors.secondaryText)
                
                Text(tab.title)
                    .font(.lumierepolis(10, weight: isSelected ? .bold : .regular))
                    .foregroundColor(isSelected ? AppColors.primaryWhite : AppColors.secondaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? AppColors.buttonPrimary.opacity(0.3) : Color.clear)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct TabItem {
    let title: String
    let icon: String
    let tag: Int
}

#Preview {
    ZStack {
        AppColors.backgroundGradient
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            CustomTabBar(selectedTab: .constant(0))
        }
    }
}
