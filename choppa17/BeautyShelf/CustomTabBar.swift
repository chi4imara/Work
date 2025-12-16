import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(title: "Storage", icon: "archivebox.fill", tag: 0),
        TabItem(title: "Products", icon: "heart.fill", tag: 1),
        TabItem(title: "Search", icon: "magnifyingglass", tag: 2),
        TabItem(title: "Analytics", icon: "chart.bar.fill", tag: 3),
        TabItem(title: "Settings", icon: "gearshape.fill", tag: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.tag) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab.tag,
                    action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = tab.tag
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 28)
                    .fill(.ultraThinMaterial)
                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                RoundedRectangle(cornerRadius: 28)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.3),
                                Color.white.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
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
            VStack(spacing: 6) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        AppColors.tabBarSelected,
                                        AppColors.tabBarSelected.opacity(0.8)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 36, height: 36)
                            .shadow(color: AppColors.tabBarSelected.opacity(0.5), radius: 8, x: 0, y: 4)
                            .scaleEffect(isSelected ? 1.0 : 0.8)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: isSelected ? 18 : 16, weight: isSelected ? .semibold : .medium))
                        .foregroundColor(isSelected ? AppColors.darkText : AppColors.primaryText)
                        .scaleEffect(isSelected ? 1.15 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
                }
                
                Text(tab.title)
                    .font(.ubuntu(isSelected ? 11 : 10, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? AppColors.tabBarSelected : AppColors.primaryText.opacity(0.8))
                    .scaleEffect(isSelected ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(0))
    }
    .background(BackgroundView())
}
