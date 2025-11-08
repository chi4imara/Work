import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    let tabs: [TabItem]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    selectedTab = tab
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.tabBarBackground)
                .shadow(color: Color.shadowColor, radius: 10, x: 0, y: -2)
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
                Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                    .font(.custom("Poppins-Medium", size: 20))
                    .foregroundColor(isSelected ? .tabBarSelected : .tabBarUnselected)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
                
                Text(tab.title)
                    .font(.tabBarText)
                    .foregroundColor(isSelected ? .tabBarSelected : .tabBarUnselected)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

enum TabItem: String, CaseIterable {
    case matches = "Matches"
    case tournaments = "Tournaments"
    case statistics = "Statistics"
    case players = "Players"
    case settings = "Settings"
    
    var title: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .matches:
            return "list.bullet"
        case .tournaments:
            return "trophy"
        case .statistics:
            return "chart.bar"
        case .players:
            return "person.2"
        case .settings:
            return "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .matches:
            return "list.bullet.clipboard.fill"
        case .tournaments:
            return "trophy.fill"
        case .statistics:
            return "chart.bar.fill"
        case .players:
            return "person.2.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(
            selectedTab: .constant(.matches),
            tabs: TabItem.allCases
        )
    }
    .background(AppGradient.background)
}
