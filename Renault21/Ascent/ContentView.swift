import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var hasCompleteOnboarding: Bool = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    var body: some View {
        ZStack {
            if !hasCompleteOnboarding {
                OnboardingView(isShowingOnboarding: $hasCompleteOnboarding)
                    .onDisappear {
                        appViewModel.completeOnboarding()
                    }
                    .transition(.slide)
            } else {
                NavigationStack {
                    MainTabView()
                        .environmentObject(appViewModel)
                        .transition(.opacity)
                        .navigationBarHidden(true)
                }
            }
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        TabView(selection: $appViewModel.selectedTab) {
            TodayView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Today")
                }
                .tag(0)
            
            MyItemsView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("My Items")
                }
                .tag(1)
            
            StatisticsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Statistics")
                }
                .tag(2)
            
            HistoryView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("History")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(ColorTheme.primaryAccent)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        appearance.backgroundColor = UIColor(ColorTheme.primaryBackground.opacity(0.95))
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(ColorTheme.primaryAccent)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(ColorTheme.primaryAccent),
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(ColorTheme.secondaryText)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(ColorTheme.secondaryText),
            .font: UIFont.systemFont(ofSize: 12, weight: .regular)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        UITabBar.appearance().layer.shadowColor = UIColor.black.cgColor
        UITabBar.appearance().layer.shadowOpacity = 0.1
        UITabBar.appearance().layer.shadowOffset = CGSize(width: 0, height: -2)
        UITabBar.appearance().layer.shadowRadius = 8
    }
}

#Preview {
    ContentView()
        .environmentObject(AppViewModel())
}
