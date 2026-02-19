import SwiftUI

enum TabItem: CaseIterable {
    case ideas
    case tags
    case favorites
    case statistics
    case settings
    
    var title: String {
        switch self {
        case .ideas: return "Ideas"
        case .tags: return "Tags"
        case .favorites: return "Favorites"
        case .statistics: return "Statistics"
        case .settings: return "Settings"
        }
    }
    
    var iconName: String {
        switch self {
        case .ideas: return "lightbulb"
        case .tags: return "tag"
        case .favorites: return "heart"
        case .statistics: return "chart.bar.fill"
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
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.darkGray.opacity(0.2), radius: 10, x: 0, y: 5)
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
                    .font(.system(size: 18, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? AppColors.purple : AppColors.mediumGray)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.title)
                    .font(.bauhausLight(10))
                    .foregroundColor(isSelected ? AppColors.purple : AppColors.mediumGray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? AppColors.purple.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct MainTabView: View {
    @State private var selectedTab: TabItem = .ideas
    @EnvironmentObject var makeupStore: MakeupStore
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
                Group {
                    switch selectedTab {
                    case .ideas:
                        IdeasView()
                    case .tags:
                        TagsView(selectedTab: $selectedTab)
                    case .favorites:
                        FavoritesView()
                    case .statistics:
                        StatisticsView()
                    case .settings:
                        SettingsView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(MakeupStore())
    }
}
