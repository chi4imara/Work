import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HistoryView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("History")
                }
                .tag(0)
            
            ColorsView()
                .tabItem {
                    Image(systemName: "paintpalette.fill")
                    Text("Colors")
                }
                .tag(1)
            
            IdeasView()
                .tabItem {
                    Image(systemName: "lightbulb.fill")
                    Text("Ideas")
                }
                .tag(2)
            
            StatisticsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Stats")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(AppColors.yellowAccent)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.yellowAccent)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.yellowAccent),
            .font: UIFont(name: "PlayfairDisplay-Medium", size: 10) ?? UIFont.systemFont(ofSize: 10)
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppColors.secondaryText)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.secondaryText),
            .font: UIFont(name: "PlayfairDisplay-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
