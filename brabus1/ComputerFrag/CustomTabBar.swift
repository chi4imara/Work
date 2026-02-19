import SwiftUI

enum TabItem: String, CaseIterable {
    case devices = "My Tech"
    case categories = "Categories"
    case upgrades = "Upgrade Plan"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .devices:
            return "desktopcomputer"
        case .categories:
            return "square.grid.2x2"
        case .upgrades:
            return "list.clipboard"
        case .statistics:
            return "chart.bar.fill"
        case .settings:
            return "gearshape"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .frame(height: 70)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(ColorTheme.tabBarBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(ColorTheme.cardBorder, lineWidth: 1)
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
                Image(systemName: tab.icon)
                    .font(.system(size: isSelected ? 20 : 18, weight: .medium))
                    .foregroundColor(isSelected ? ColorTheme.tabBarSelected : ColorTheme.tabBarUnselected)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.rawValue)
                    .font(.ubuntu(10, weight: .medium))
                    .foregroundColor(isSelected ? ColorTheme.tabBarSelected : ColorTheme.tabBarUnselected)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? ColorTheme.accentYellow.opacity(0.2) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ZStack {
        ColorTheme.backgroundGradient
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            CustomTabBar(selectedTab: .constant(.devices))
        }
    }
}