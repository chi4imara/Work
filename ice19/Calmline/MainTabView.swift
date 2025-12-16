import SwiftUI

struct MainTabView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TodayScreen(selectedTab: $selectedTab)
                .environmentObject(dataManager)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Today")
                }
                .tag(0)
            
            HistoryScreen(selectedTab: $selectedTab)
                .environmentObject(dataManager)
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("History")
                }
                .tag(1)
            
            StatisticsScreen(selectedTab: $selectedTab)
                .environmentObject(dataManager)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Stats")
                }
                .tag(2)
            
            ValuesScreen()
                .environmentObject(dataManager)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Values")
                }
                .tag(3)
            
            SettingsScreen()
                .environmentObject(dataManager)
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(ColorManager.shared.primaryPurple)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        
        appearance.selectionIndicatorTintColor = UIColor(ColorManager.shared.primaryPurple)
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.black)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.black),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(ColorManager.shared.primaryPurple)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(ColorManager.shared.primaryPurple),
            .font: UIFont.systemFont(ofSize: 10, weight: .bold)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
}
