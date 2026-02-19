import SwiftUI

struct MainTabView: View {
    @ObservedObject var bagStore: BagStore
    @State private var selectedTab: TabItem = .bags
    
    var body: some View {
        TabView(selection: $selectedTab) {
            BagsListView(bagStore: bagStore)
                .tabItem {
                    Image(systemName: "bag")
                    Text("Bags")
                        .font(.bellGothic(12))
                }
                .tag(TabItem.bags)
            
            CategoriesView(bagStore: bagStore, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Categories")
                        .font(.bellGothic(12))
                }
                .tag(TabItem.categories)
            
            FavoritesView(bagStore: bagStore)
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorites")
                        .font(.bellGothic(12))
                }
                .tag(TabItem.favorites)
            
            StatisticsView(bagStore: bagStore)
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Statistics")
                        .font(.bellGothic(12))
                }
                .tag(TabItem.statistics)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                        .font(.bellGothic(12))
                }
                .tag(TabItem.settings)
        }
        .accentColor(.appPrimaryBlue)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 12)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.appPrimaryBlue)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.appPrimaryBlue),
            .font: UIFont.boldSystemFont(ofSize: 12)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
