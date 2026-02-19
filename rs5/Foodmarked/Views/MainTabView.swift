import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var productStore: ProductStore
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ProductCatalogView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Catalog")
                }
                .tag(0)
            
            QuickAddView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Add")
                }
                .tag(1)
            
            CategoriesView()
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Categories")
                }
                .tag(2)
            
            StatisticsView()
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
        .accentColor(ColorManager.primaryBlue)
    }
}
