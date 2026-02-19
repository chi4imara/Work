import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = WardrobeViewModel()

    var body: some View {
        TabView {
            ShoppingListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("List")
                }
            
            CategoriesView()
                .tabItem {
                    Image(systemName: "folder")
                    Text("Categories")
                }
            
            PurchasedView()
                .tabItem {
                    Image(systemName: "checkmark.circle")
                    Text("Purchased")
                }
            
            StatisticsView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Statistics")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .accentColor(Color.primaryYellow)
        .environmentObject(viewModel)
    }
}

#Preview {
    MainTabView()
}
