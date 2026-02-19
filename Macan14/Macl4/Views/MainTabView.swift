import SwiftUI

struct MainTabView: View {
    @StateObject private var storeViewModel = StoreViewModel()
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            StoreListView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "bag.fill")
                    Text("Stores")
                }
                .environmentObject(storeViewModel)
                .tag(0)
            
            CategoriesView()
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Categories")
                }
                .environmentObject(storeViewModel)
                .tag(1)

            AddStoreView(viewModel: storeViewModel, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Add")
                }
                .tag(2)

            StatsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Stats")
                }
                .environmentObject(storeViewModel)
                .tag(3)

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(.appAccent)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.appAccent)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.appAccent),
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.appTextSecondary)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.appTextSecondary),
            .font: UIFont.systemFont(ofSize: 12, weight: .regular)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
}
