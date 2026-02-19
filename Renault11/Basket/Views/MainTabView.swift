import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = PurchaseViewModel()
    
    var body: some View {
        TabView {
            TodayView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Today")
                }
            
            MyPurchasesView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "bag.fill")
                    Text("My Purchases")
                }
            
            HistoryView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "calendar")
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
        .accentColor(Color.theme.primaryYellow)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        appearance.backgroundColor = UIColor(Color.theme.primaryBlue.opacity(0.8))
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.theme.primaryYellow)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.theme.primaryYellow),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.black)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.black),
            .font: UIFont.systemFont(ofSize: 10, weight: .regular)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
}
