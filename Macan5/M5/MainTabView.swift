import SwiftUI
import StoreKit

struct MainTabView: View {
    @StateObject private var productStore = ProductStore()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MyStockView()
                .environmentObject(productStore)
                .tabItem {
                    Image(systemName: "cube.box.fill")
                    Text("Stock")
                }
                .tag(0)
            
            CategoriesView()
                .environmentObject(productStore)
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Categories")
                }
                .tag(1)
            
            FiltersView(selectedTab: $selectedTab)
                .environmentObject(productStore)
                .tabItem {
                    Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    Text("Filters")
                }
                .tag(2)
            
            ShoppingListView()
                .environmentObject(productStore)
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Shopping")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(ColorManager.primaryYellow)
    }
}

#Preview {
    MainTabView()
}
