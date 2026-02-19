import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = MakeupLookViewModel()
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MyLooksView(selectedTab: $selectedTab)
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "face.smiling")
                    Text("My Looks")
                }
                .tag(0)
            
            CategoriesView()
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "folder")
                    Text("Categories")
                }
                .tag(1)
            
            AddFullScreenView(selectedTab: $selectedTab)
                .environmentObject(viewModel)
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Look")
                }
                .tag(2)
            
            FiltersView(selectedTab: $selectedTab)
                .environmentObject(viewModel)
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
        .accentColor(AppColors.primaryYellow)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.white.withAlphaComponent(0.95)
            
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppColors.secondaryText)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor(AppColors.secondaryText),
                .font: UIFont(name: "PlayfairDisplay-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10)
            ]
            
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.primaryYellow)
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor(AppColors.primaryYellow),
                .font: UIFont(name: "PlayfairDisplay-SemiBold", size: 10) ?? UIFont.boldSystemFont(ofSize: 10)
            ]
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    MainTabView()
}
