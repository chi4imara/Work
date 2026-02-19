import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Today")
                }
                .tag(0)
            
            PracticesView()
                .tabItem {
                    Image(systemName: "heart.circle.fill")
                    Text("Practices")
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
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(ColorTheme.accentColor)
    }
}

#Preview {
    MainTabView()
        .environmentObject(DataManager.shared)
}