import SwiftUI

enum TabItem: String, CaseIterable {
    case catalog = "Catalog"
    case statistics = "Statistics"
    case usage = "Usage"
    case extra = "Quick"
    case settings = "Settings"
    
    var iconName: String {
        switch self {
        case .catalog:
            return "list.bullet"
        case .statistics:
            return "chart.bar"
        case .usage:
            return "clock"
        case .extra:
            return "bolt.fill"
        case .settings:
            return "gearshape"
        }
    }
    
    var title: String {
        return self.rawValue
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
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.cardGradient)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
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
                    .font(.system(size: isSelected ? 22 : 18, weight: .medium))
                    .foregroundColor(isSelected ? Color.theme.orange : Color.theme.white.opacity(0.6))
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.title)
                    .font(.playfairDisplay(10, weight: .medium))
                    .foregroundColor(isSelected ? Color.theme.orange : Color.theme.white.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? Color.theme.white.opacity(0.1) : Color.clear)
            )
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.catalog))
    }
    .background(Color.theme.backgroundGradient)
}
