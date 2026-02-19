import SwiftUI

struct MainTabView: View {
    @StateObject private var productViewModel = ProductViewModel()
    
    var body: some View {
        TabView {
            CatalogView()
                .environmentObject(productViewModel)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Catalog")
                }
                .tag(0)
            
            CategoriesView()
                .environmentObject(productViewModel)
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Categories")
                }
                .tag(1)
            
            FavoritesView()
                .environmentObject(productViewModel)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
                .tag(2)
            
            StatisticsView()
                .environmentObject(productViewModel)
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
        .accentColor(.primaryYellow)
    }
}

#Preview {
    MainTabView()
}
