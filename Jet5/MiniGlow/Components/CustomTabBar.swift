import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.cardBorder, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
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
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? Color.primaryPurple : Color.textSecondary)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.title)
                    .font(.captionMedium)
                    .foregroundColor(isSelected ? Color.primaryPurple : Color.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? Color.primaryPurple.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

enum TabItem: String, CaseIterable {
    case sets = "Sets"
    case products = "Products"
    case notes = "Notes"
    case search = "Search"
    case settings = "Settings"
    
    var title: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .sets:
            return "briefcase"
        case .products:
            return "waterbottle"
        case .notes:
            return "note.text"
        case .search:
            return "magnifyingglass"
        case .settings:
            return "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .sets:
            return "briefcase.fill"
        case .products:
            return "waterbottle.fill"
        case .notes:
            return "note.text"
        case .search:
            return "magnifyingglass"
        case .settings:
            return "gearshape.fill"
        }
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.sets))
    }
    .background(AnimatedBackground())
}
