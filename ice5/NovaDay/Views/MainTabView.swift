import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var memoryStore: MemoryStore
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView(memoryStore: memoryStore, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Today")
                }
                .tag(0)
            
            FavoritesView(memoryStore: memoryStore, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
                .tag(1)
            
            CalendarView(memoryStore: memoryStore)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(2)
            
            SummaryView(memoryStore: memoryStore)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Summary")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(AppColors.primaryBlue)
    }
}

#Preview {
    MainTabView()
        .environmentObject(MemoryStore())
}
