import SwiftUI

struct MainTabView: View {
    @StateObject private var dataManager = TermsDataManager()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TermsListView()
                .environmentObject(dataManager)
                .tabItem {
                    Image(systemName: "book")
                    Text("Terms")
                }
                .tag(0)
            
            CalendarView()
                .environmentObject(dataManager)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(1)
            
            StatisticsView()
                .environmentObject(dataManager)
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Statistics")
                }
                .tag(2)
            
            SearchView()
                .environmentObject(dataManager)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(3)
            
            SettingsView()
                .environmentObject(dataManager)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(AppColors.accentYellow)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(AppColors.primaryBlue.opacity(0.9))
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.black)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.black),
            .font: UIFont(name: "Ubuntu-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.accentYellow)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.accentYellow),
            .font: UIFont(name: "Ubuntu-Medium", size: 12) ?? UIFont.boldSystemFont(ofSize: 12)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
}
