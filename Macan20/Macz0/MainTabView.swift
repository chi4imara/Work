import SwiftUI

struct MainTabView: View {
    @ObservedObject var viewModel: CosmeticViewModel
    @State private var selectedTab = 0
    @State private var showingAddProduct = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CatalogView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Catalog")
                }
                .tag(0)
            
            CategoriesView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "square.grid.3x3")
                    Text("Categories")
                }
                .tag(1)
            
            AddProductView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Add")
                }
                .tag(2)
            
            FiltersView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                    Text("Filters")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(ColorTheme.lightBlue)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(ColorTheme.darkBlue)
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(ColorTheme.textSecondary)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(ColorTheme.textSecondary),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(ColorTheme.lightBlue)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(ColorTheme.lightBlue),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
