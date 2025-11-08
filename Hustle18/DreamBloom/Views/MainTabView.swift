import SwiftUI

struct MainTabView: View {
    @ObservedObject var dreamStore: DreamStore
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                DreamListView(dreamStore: dreamStore)
            }
            .tabItem {
                Image(systemName: selectedTab == 0 ? "moon.stars.fill" : "moon.stars")
                Text("Dreams")
            }
            .tag(0)
            
            NavigationView {
                FavoritesView(dreamStore: dreamStore)
            }
            .tabItem {
                Image(systemName: selectedTab == 1 ? "star.fill" : "star")
                Text("Favorites")
            }
            .tag(1)
            
            NavigationView {
                StatisticsView(dreamStore: dreamStore)
            }
            .tabItem {
                Image(systemName: selectedTab == 2 ? "chart.bar.fill" : "chart.bar")
                Text("Statistics")
            }
            .tag(2)
            
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Image(systemName: selectedTab == 3 ? "gearshape.fill" : "gearshape")
                Text("Settings")
            }
            .tag(3)
        }
        .accentColor(.dreamYellow)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MainTabView(dreamStore: DreamStore())
}
