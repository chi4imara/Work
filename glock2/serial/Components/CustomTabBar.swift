import SwiftUI

enum TabItem: String, CaseIterable {
    case home = "Series"
    case categories = "Categories"
    case progress = "Progress"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .home:
            return "tv"
        case .categories:
            return "folder"
        case .progress:
            return "chart.pie"
        case .settings:
            return "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .home:
            return "tv.fill"
        case .categories:
            return "folder.fill"
        case .progress:
            return "chart.pie.fill"
        case .settings:
            return "gearshape.fill"
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
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(
            ZStack {
                Color.white
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: -4)
                
                LinearGradient(
                    gradient: Gradient(colors: [Color.lightBlue.opacity(0.3), Color.clear]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 1)
                .frame(maxHeight: .infinity, alignment: .top)
            }
        )
        .clipShape(
            .rect(
                topLeadingRadius: 20,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 20
            )
        )
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.primaryBlue, Color.secondaryBlue]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)
                            .shadow(color: Color.primaryBlue.opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                    
                    Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? .white : .textSecondary)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                
                Text(tab.rawValue)
                    .font(.captionMedium)
                    .foregroundColor(isSelected ? .primaryBlue : .textSecondary)
                    .scaleEffect(isSelected ? 1.05 : 1.0)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
