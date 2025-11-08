import SwiftUI

struct MainTabView: View {
    @ObservedObject var weatherData: WeatherDataManager
    @ObservedObject var appState: AppStateManager
    
    var body: some View {
        TabView(selection: $appState.currentTab) {
            CalendarView(weatherData: weatherData, appState: appState)
                .tabItem {
                    Image(systemName: AppTab.calendar.icon)
                    Text(AppTab.calendar.title)
                }
                .tag(AppTab.calendar)
            
            ListView(weatherData: weatherData, appState: appState)
                .tabItem {
                    Image(systemName: AppTab.list.icon)
                    Text(AppTab.list.title)
                }
                .tag(AppTab.list)
            
            StatisticsView(weatherData: weatherData, appState: appState)
                .tabItem {
                    Image(systemName: AppTab.statistics.icon)
                    Text(AppTab.statistics.title)
                }
                .tag(AppTab.statistics)
            
            SettingsView(appState: appState)
                .tabItem {
                    Image(systemName: AppTab.settings.icon)
                    Text(AppTab.settings.title)
                }
                .tag(AppTab.settings)
        }
        .accentColor(AppColors.primaryOrange)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(AppColors.backgroundBlue).withAlphaComponent(0.9)
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppColors.primaryText).withAlphaComponent(0.6)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.primaryText).withAlphaComponent(0.6),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.primaryOrange)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.primaryOrange),
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView(weatherData: WeatherDataManager(), appState: AppStateManager())
}
