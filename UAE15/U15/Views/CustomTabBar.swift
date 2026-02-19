import SwiftUI

enum TabItem: String, CaseIterable {
    case journal = "Journal"
    case statistics = "Statistics" 
    case add = "Add"
    case insights = "Insights"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .journal:
            return "book.fill"
        case .statistics:
            return "chart.bar.fill"
        case .add:
            return "plus.circle.fill"
        case .insights:
            return "lightbulb.fill"
        case .settings:
            return "gearshape.fill"
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
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(ColorManager.shared.tabBarBackground)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: -2)
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
                ZStack {
                    if tab == .add {
                        Circle()
                            .fill(ColorManager.shared.accentOrange)
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: tab.icon)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(ColorManager.shared.primaryText)
                    } else {
                        Image(systemName: tab.icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(isSelected ? ColorManager.shared.tabBarSelected : ColorManager.shared.tabBarUnselected)
                    }
                }
                
                if tab != .add {
                    Text(tab.title)
                        .font(FontManager.playfairRegular(size: 10))
                        .foregroundColor(isSelected ? ColorManager.shared.tabBarSelected : ColorManager.shared.tabBarUnselected)
                }
            }
            .frame(maxWidth: .infinity)
            .scaleEffect(isSelected && tab != .add ? 1.1 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.journal))
    }
    .background(ColorManager.shared.primaryBackground)
}
