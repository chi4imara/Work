import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var brandStore = BrandStore()

    var body: some View {
        TabView(selection: $selectedTab) {
            BrandCatalogView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "heart.fill" : "heart")
                    Text("Catalog")
                }
                .tag(0)
            
            CategoriesView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "folder.fill" : "folder")
                    Text("Categories")
                }
                .tag(1)
            
            FavoritesView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "star.fill" : "star")
                    Text("Favorites")
                }
                .tag(2)
            
            StatisticsView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "chart.bar.fill" : "chart.bar")
                    Text("Statistics")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(AppColors.primaryYellow)
        .environmentObject(brandStore)
    }
}

#Preview {
    MainTabView()
}
