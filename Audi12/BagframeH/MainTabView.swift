import SwiftUI

struct MainTabView: View {
    @StateObject private var bagViewModel = BagViewModel()
    
    var body: some View {
        TabView {
            MyBagsView()
                .environmentObject(bagViewModel)
                .tabItem {
                    Image(systemName: "handbag")
                    Text("Bags")
                }
            
            DaySelectionView()
                .environmentObject(bagViewModel)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Day Selection")
                }
            
            SearchView()
                .environmentObject(bagViewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            FavoritesView()
                .environmentObject(bagViewModel)
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorites")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
        .accentColor(AppColors.yellow)
    }
}


#Preview {
    MainTabView()
}
