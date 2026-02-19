import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            MealPlanView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Plan")
                }
                .tag(1)
            
            EnergyView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Energy")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(ColorTheme.primaryYellow)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
}