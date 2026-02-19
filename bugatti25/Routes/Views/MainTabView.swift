import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = AppViewModel()
    
    var body: some View {
        TabView {
            TodayView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Today")
                }
            
            MyPlacesView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "location.fill")
                    Text("My Places")
                }
            
            HistoryView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("History")
                }
            
            StatisticsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Statistics")
                }
            
            SettingsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .accentColor(.primaryYellow)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        
        appearance.selectionIndicatorTintColor = UIColor(Color.primaryYellow)
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.primaryBlue)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.primaryBlue),
            .font: UIFont(name: "PlayfairDisplay-Medium", size: 10) ?? UIFont.systemFont(ofSize: 10)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.primaryYellow)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.primaryYellow),
            .font: UIFont(name: "PlayfairDisplay-SemiBold", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
