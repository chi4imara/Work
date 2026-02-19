import SwiftUI

struct MainTabView: View {
    @StateObject private var fragranceViewModel = FragranceViewModel()
    
    var body: some View {
        TabView {
            FragrancesView()
                .environmentObject(fragranceViewModel)
                .tabItem {
                    Image(systemName: "drop.fill")
                    Text("Fragrances")
                }
                .tag(0)
            
            CategoriesView()
                .environmentObject(fragranceViewModel)
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Categories")
                }
                .tag(1)
            
            FavoritesView()
                .environmentObject(fragranceViewModel)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
                .tag(2)
            
            StatisticsView()
                .environmentObject(fragranceViewModel)
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
        .accentColor(AppColors.primaryYellow)
        .background(AppColors.backgroundGradient)
    }
}

#Preview {
    MainTabView()
}
