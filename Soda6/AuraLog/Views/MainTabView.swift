import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var store: PerfumeStore
    
    var body: some View {
        TabView {
            CatalogView(store: store)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Catalog")
                }
            
            StatisticsView(store: store)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Statistics")
                }
            
            CombinationsView(store: store)
                .tabItem {
                    Image(systemName: "lightbulb.fill")
                    Text("Combinations")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .accentColor(.primaryYellow)
    }
}
