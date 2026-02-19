import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = DailyEntryViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MyDayView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "sun.max.fill" : "sun.max")
                    Text("My Day")
                }
                .tag(0)
            
            HabitsView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "repeat.circle.fill" : "repeat.circle")
                    Text("Habits")
                }
                .tag(1)
            
            StatisticsView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "chart.bar.fill" : "chart.bar")
                    Text("Statistics")
                }
                .tag(2)
            
            HistoryView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "calendar.circle.fill" : "calendar.circle")
                    Text("History")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                    Text("Settings")
                }
                .tag(4)
        }
        .environmentObject(viewModel)
        .accentColor(AppColors.accentYellow)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(AppColors.primaryBlue.opacity(0.9))
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.black)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.black),
            .font: UIFont(name: "PlayfairDisplay-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.accentYellow)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.accentYellow),
            .font: UIFont(name: "PlayfairDisplay-Medium", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
