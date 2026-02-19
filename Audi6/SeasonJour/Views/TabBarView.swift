import SwiftUI

struct TabBarView: View {
    @StateObject private var viewModel = SeasonItemViewModel()

    var body: some View {
        TabView {
            MainView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            SeasonsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Seasons")
                }
            
            FavoritesView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorites")
                }
            
            StatisticsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Statistics")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
        .accentColor(AppColors.primaryBlue)
    }
}

#Preview {
    TabBarView()
}
