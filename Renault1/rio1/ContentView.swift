import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var store: AppDataStore
    
    var body: some View {
        Group {
            if !appState.hasCompletedOnboarding {
                OnboardingView()
            } else {
                NavigationStack {
                    MainTabView()
                        .navigationBarHidden(true)
                }
            }
        }
        .onAppear {
            store.loadFromStorage()
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var store: AppDataStore
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            TodayView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Today")
                }
                .tag(0)
            
            RitualsView()
                .tabItem {
                    Image(systemName: "leaf.fill")
                    Text("My Rituals")
                }
                .tag(1)
            
            HistoryView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("History")
                }
                .tag(2)
            
            StatisticsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Statistics")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(AppColors.primary)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.primary)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.primary),
            .font: UIFont.systemFont(ofSize: 12, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppColors.text.opacity(0.6))
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.text.opacity(0.6)),
            .font: UIFont.systemFont(ofSize: 12, weight: .regular)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
        .environmentObject(AppDataStore())
}
