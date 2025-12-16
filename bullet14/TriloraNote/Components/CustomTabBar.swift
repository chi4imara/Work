import SwiftUI

enum TabItem: CaseIterable {
    case home
    case archive
    case quotes
    case dayMap
    case settings
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .archive: return "Archive"
        case .quotes: return "Quotes"
        case .dayMap: return "Day Map"
        case .settings: return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house"
        case .archive: return "folder"
        case .quotes: return "book"
        case .dayMap: return "map"
        case .settings: return "gearshape"
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
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.tabBarBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                )
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
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? Color.theme.tabBarSelected : Color.theme.tabBarUnselected)
                
                Text(tab.title)
                    .font(.ubuntu(10, weight: .medium))
                    .foregroundColor(isSelected ? Color.theme.tabBarSelected : Color.theme.tabBarUnselected)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? Color.theme.primaryPurple.opacity(0.2) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ZStack {
        AnimatedBackground()
        
        VStack {
            Spacer()
            CustomTabBar(selectedTab: .constant(.home))
        }
    }
}
