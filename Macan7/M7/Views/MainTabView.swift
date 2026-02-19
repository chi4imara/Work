import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MyShootsView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "camera.fill" : "camera")
                    Text("Shoots")
                }
                .tag(0)
            
            CategoriesView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "folder.fill" : "folder")
                    Text("Categories")
                }
                .tag(1)
            
            NavigationView {
                FiltersView()
            }
            .tabItem {
                Image(systemName: selectedTab == 2 ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                Text("Filters")
            }
            .tag(2)
            
            StatisticsView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "chart.bar.fill" : "chart.bar")
                    Text("Statistics")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(.appPrimary)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.appPrimary)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.appPrimary),
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.appSecondaryText)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.appSecondaryText),
            .font: UIFont.systemFont(ofSize: 12, weight: .regular)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
}
