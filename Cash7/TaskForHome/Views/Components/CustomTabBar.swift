import SwiftUI

enum TabItem: String, CaseIterable {
    case today = "Today"
    case rooms = "Rooms"
    case statistics = "Statistics"
    case archive = "Archive"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .today: return "house.fill"
        case .rooms: return "door.left.hand.open"
        case .statistics: return "chart.bar.fill"
        case .archive: return "archivebox.fill"
        case .settings: return "gearshape.fill"
        }
    }
    
    var title: String {
        return self.rawValue
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
                .fill(Color.pureWhite)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -2)
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
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isSelected ? .primaryBlue : .mediumGray)
                
                Text(tab.title)
                    .font(.customCaption())
                    .foregroundColor(isSelected ? .primaryBlue : .mediumGray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.lightBlue.opacity(0.2) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.today))
}

