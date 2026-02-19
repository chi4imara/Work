import SwiftUI

enum TabItem: String, CaseIterable {
    case notes = "Notes"
    case categories = "Categories"
    case favorites = "Favorites"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .notes:
            return "note.text"
        case .categories:
            return "folder"
        case .favorites:
            return "heart"
        case .statistics:
            return "chart.bar"
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
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.cardBackground)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
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
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? Color.theme.accentYellow : Color.theme.secondaryText)
                
                Text(tab.title)
                    .font(.ubuntu(10, weight: .medium))
                    .foregroundColor(isSelected ? Color.theme.accentYellow : Color.theme.secondaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? Color.theme.accentYellow.opacity(0.2) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.notes))
    }
    .background(Color.theme.primaryGradient)
}
