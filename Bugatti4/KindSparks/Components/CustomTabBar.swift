import SwiftUI

enum TabItem: CaseIterable {
    case people
    case allIdeas
    case calendar
    case statistics
    case settings
    
    var title: String {
        switch self {
        case .people: return "People"
        case .allIdeas: return "All Ideas"
        case .calendar: return "Calendar"
        case .statistics: return "Statistics"
        case .settings: return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .people: return "person.2.fill"
        case .allIdeas: return "lightbulb.fill"
        case .calendar: return "calendar"
        case .statistics: return "chart.bar.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    selectedTab = tab
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.appCard)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
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
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .appAccent : .appTextSecondary)
                
                Text(tab.title)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(isSelected ? .appAccent : .appTextSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}