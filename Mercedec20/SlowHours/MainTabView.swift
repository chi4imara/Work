import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        TabView(selection: $appViewModel.selectedTab) {
            HomeView(appViewModel: appViewModel)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            EventsView(appViewModel: appViewModel)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("My Events")
                }
                .tag(1)
            
            ProgressView(appViewModel: appViewModel)
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Progress")
                }
                .tag(2)
            
            ProfileView(appViewModel: appViewModel)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
            
            SettingsView(appViewModel: appViewModel)
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(ColorTheme.primaryBlue)
        .sheet(isPresented: $appViewModel.showAddActivitySheet) {
            AddActivityView(appViewModel: appViewModel)
        }
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.gray,
            .font: UIFont(name: "PlayfairDisplay-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(ColorTheme.primaryBlue)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(ColorTheme.primaryBlue),
            .font: UIFont(name: "PlayfairDisplay-Medium", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppViewModel())
}
