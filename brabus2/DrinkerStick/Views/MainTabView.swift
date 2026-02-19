import SwiftUI

struct MainTabView: View {
    @StateObject private var drinkViewModel = DrinkViewModel()
    
    var body: some View {
        TabView {
            CatalogView(viewModel: drinkViewModel)
                .tabItem {
                    Image(systemName: "wineglass")
                    Text("Catalog")
                }
            
            SearchView(viewModel: drinkViewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            CalendarView(viewModel: drinkViewModel)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
            
            StatisticsView(viewModel: drinkViewModel)
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
        .accentColor(ColorTheme.primaryYellow)
    }
}

#Preview {
    MainTabView()
}
