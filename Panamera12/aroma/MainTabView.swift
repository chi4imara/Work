import SwiftUI

struct MainTabView: View {
    @ObservedObject var viewModel: FragranceViewModel
    
    var body: some View {
        TabView {
            MyFragrancesView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("Fragrances")
                }
                .tag(0)
            
            CategoriesView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "square.grid.3x3")
                    Text("Categories")
                }
                .tag(1)
            
            FavoritesView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorites")
                }
                .tag(2)
            
            StatisticsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Statistics")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(.appPrimaryYellow)
    }
}


#Preview {
    MainTabView(viewModel: FragranceViewModel())
}
