import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedTab: TabSelection = .challenges
    
    var body: some View {
        TabView(selection: $selectedTab) {
            RandomChallengeView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: TabSelection.challenges.iconName)
                    Text(TabSelection.challenges.title)
                }
                .tag(TabSelection.challenges)
            
            CategoriesView()
                .tabItem {
                    Image(systemName: TabSelection.categories.iconName)
                    Text(TabSelection.categories.title)
                }
                .tag(TabSelection.categories)
            
            CreateChallengeView()
                .tabItem {
                    Image(systemName: TabSelection.create.iconName)
                    Text(TabSelection.create.title)
                }
                .tag(TabSelection.create)
            
            FavoritesView()
                .tabItem {
                    Image(systemName: TabSelection.favorites.iconName)
                    Text(TabSelection.favorites.title)
                }
                .tag(TabSelection.favorites)
            
            SettingsView()
                .tabItem {
                    Image(systemName: TabSelection.settings.iconName)
                    Text(TabSelection.settings.title)
                }
                .tag(TabSelection.settings)
        }
        .accentColor(AppColors.primary)
        .environmentObject(dataManager)
    }
}

#Preview {
    MainTabView()
        .environmentObject(DataManager.shared)
}
