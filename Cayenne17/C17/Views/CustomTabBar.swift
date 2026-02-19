import SwiftUI

enum TabItem: String, CaseIterable {
    case newPhase = "New Phase"
    case cycles = "Cycles"
    case results = "Results"
    case analytics = "Analytics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .newPhase:
            return "plus.circle"
        case .cycles:
            return "repeat.circle"
        case .results:
            return "chart.bar"
        case .analytics:
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
                    selectedTab = tab
                }
            }
        }
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.cardGradient)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: -5)
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
                    .font(.system(size: isSelected ? 22 : 18, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.orange : AppColors.white.opacity(0.6))
                
                Text(tab.rawValue)
                    .font(.custom("PlayfairDisplay-Regular", size: 10))
                    .foregroundColor(isSelected ? AppColors.orange : AppColors.white.opacity(0.6))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(isSelected ? AppColors.orange.opacity(0.2) : Color.clear)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.newPhase))
    }
    .background(AppColors.backgroundGradient)
}
