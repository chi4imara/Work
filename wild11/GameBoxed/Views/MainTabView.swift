import SwiftUI

struct MainTabView: View {
    @StateObject private var gameViewModel = GameViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            GameCatalogView(viewModel: gameViewModel)
                .tabItem {
                    Image(systemName: "gamecontroller.fill")
                    Text("Catalog")
                }
                .tag(0)
            
            CategoriesView(viewModel: gameViewModel, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "tag.fill")
                    Text("Categories")
                }
                .tag(1)
            
            FavoritesView(viewModel: gameViewModel, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
                .tag(2)
            
            StatisticsView(viewModel: gameViewModel)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Statistics")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(ColorManager.primaryBlue)
    }
}


#Preview {
    MainTabView()
}
