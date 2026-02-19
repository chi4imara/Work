import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        TabItem(title: "Add", icon: "plus.circle", selectedIcon: "plus.circle.fill"),
        TabItem(title: "Catalog", icon: "list.bullet", selectedIcon: "list.bullet.circle.fill"),
        TabItem(title: "Types", icon: "folder", selectedIcon: "folder.fill"),
        TabItem(title: "Search", icon: "magnifyingglass", selectedIcon: "magnifyingglass.circle.fill"),
        TabItem(title: "Settings", icon: "gearshape", selectedIcon: "gearshape.fill")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                TabBarButton(
                    tab: tabs[index],
                    isSelected: selectedTab == index,
                    action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = index
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            ZStack {
                AppColors.cardGradient
                    .blur(radius: 20)
                
                RoundedRectangle(cornerRadius: 25)
                    .fill(AppColors.darkBlue.opacity(0.9))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(AppColors.lightBlue.opacity(0.2), lineWidth: 1)
                    )
            }
        )
        .cornerRadius(25)
        .shadow(color: AppColors.darkBlue.opacity(0.3), radius: 10, x: 0, y: 5)
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
                            .fill(AppColors.buttonGradient)
                            .frame(width: 32, height: 32)
                            .scaleEffect(isSelected ? 1.0 : 0.8)
                    }
                    
                    Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isSelected ? .appWhite : .appMediumGray)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                
                Text(tab.title)
                    .font(.playfairDisplay(size: 10, weight: .medium))
                    .foregroundColor(isSelected ? .appLightBlue : .appMediumGray)
                    .scaleEffect(isSelected ? 1.0 : 0.9)
            }
            .frame(maxWidth: .infinity)
            .animation(.easeInOut(duration: 0.3), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TabItem {
    let title: String
    let icon: String
    let selectedIcon: String
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
