import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(0)
            
            AllSmilesView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "book.fill" : "book")
                    Text("All Records")
                }
                .tag(1)
            
            ThoughtsView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "lightbulb.fill" : "lightbulb")
                    Text("Thoughts")
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
        .accentColor(AppColors.yellow)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor(AppColors.skyBlue.opacity(0.9))
            
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppColors.white.opacity(0.6))
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor(Color.black),
                .font: UIFont(name: "Ubuntu-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10)
            ]
            
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.yellow)
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor(AppColors.yellow),
                .font: UIFont(name: "Ubuntu-Medium", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .medium)
            ]
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    MainTabView()
}

