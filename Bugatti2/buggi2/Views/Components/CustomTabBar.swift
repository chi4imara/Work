import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        TabItem(title: "Inventory", icon: "archivebox.fill", index: 0),
        TabItem(title: "Calendar", icon: "calendar", index: 1),
        TabItem(title: "Search", icon: "magnifyingglass", index: 2),
        TabItem(title: "Statistics", icon: "chart.bar.fill", index: 3),
        TabItem(title: "Settings", icon: "gearshape.fill", index: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.index) { tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab.index
                    }
                }) {
                    VStack(spacing: 4) {
                        ZStack {
                            if selectedTab == tab.index {
                                Circle()
                                    .fill(AppColors.primaryYellow)
                                    .frame(width: 40, height: 40)
                                    .transition(.scale.combined(with: .opacity))
                            }
                            
                            Image(systemName: tab.icon)
                                .font(.system(size: 20, weight: .medium))
.foregroundColor(
                                    selectedTab == tab.index
                                    ? AppColors.backgroundWhite
                                    : AppColors.primaryTextWhite
                                )
                        }
                        .frame(height: 40)
                        
                        Text(tab.title)
                            .font(.playfairDisplay(12, weight: .medium))
.foregroundColor(
                                selectedTab == tab.index
                                ? AppColors.backgroundWhite
                                : AppColors.primaryTextWhite
                            )
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 10, x: 0, y: -2)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
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
    .background(GridBackgroundView())
}
