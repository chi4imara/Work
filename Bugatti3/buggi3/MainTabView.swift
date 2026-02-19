import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = ExperimentViewModel()
    
    var body: some View {
        TabView {
            ExperimentsListView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "flask")
                    Text("Experiments")
                        .font(.ubuntu(12))
                }
                .environmentObject(viewModel)
            
            SearchView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                        .font(.ubuntu(12))
                }
                .environmentObject(viewModel)
            
            CalendarView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                        .font(.ubuntu(12))
                }
                .environmentObject(viewModel)
            
            StatisticsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Statistics")
                        .font(.ubuntu(12))
                }
                .environmentObject(viewModel)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                        .font(.ubuntu(12))
                }
                .environmentObject(viewModel)
        }
        .accentColor(Color.theme.lightBlue)
        .preferredColorScheme(.light)
    }
}

#Preview {
    MainTabView()
}
