import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = EventsViewModel()
    
    var body: some View {
        TabView {
            TodayView(viewModel: viewModel)
            
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("Today")
                }
                .tag(0)
            
            CalendarView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(1)
            
            ArchiveView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "archivebox.fill")
                    Text("Archive")
                }
                .tag(2)
            
            StatisticsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Statistics")
                }
                .tag(3)
            
            SettingsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(ColorTheme.primaryBlue)
    }
}
