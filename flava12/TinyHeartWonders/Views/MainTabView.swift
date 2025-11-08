import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var viewModel = WonderViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
            
            HistoryView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "clock.fill" : "clock")
                    Text("History")
                }
                .tag(1)
            
            StatisticsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "chart.bar.fill" : "chart.bar")
                    Text("Statistics")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "gearshape.fill" : "gearshape")
                    Text("Settings")
                }
                .tag(3)
        }
        .accentColor(AppColors.primaryBlue)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.white.withAlphaComponent(0.95)
            
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppColors.secondaryText)
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor(AppColors.secondaryText),
                .font: UIFont.systemFont(ofSize: 12)
            ]
            
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.white)
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor(Color.white),
                .font: UIFont.boldSystemFont(ofSize: 12)
            ]
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    MainTabView()
}
