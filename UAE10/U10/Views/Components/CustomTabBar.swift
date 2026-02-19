import SwiftUI

enum TabItem: String, CaseIterable {
    case measurements = "Measurements"
    case bodyZones = "Body Zones"
    case dynamics = "Dynamics"
    case settings = "Settings"
    
    var iconName: String {
        switch self {
        case .measurements:
            return "list.clipboard"
        case .bodyZones:
            return "figure.arms.open"
        case .dynamics:
            return "chart.line.uptrend.xyaxis"
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
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.darkBlue.opacity(0.3), radius: 10, x: 0, y: 5)
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
                Image(systemName: tab.iconName)
                    .font(.system(size: isSelected ? 20 : 18, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.orange : AppColors.white.opacity(0.6))
                
                Text(tab.rawValue)
                    .font(.ubuntu(10, weight: isSelected ? .medium : .regular))
                    .foregroundColor(isSelected ? AppColors.orange : AppColors.white.opacity(0.6))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? AppColors.orange.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
