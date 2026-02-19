import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var viewModel: DecisionViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            TabView(selection: $selectedTab) {
                DecisionsListView(selectedTab: $selectedTab)
                    .environmentObject(viewModel)
                    .tabItem {
                        Image(systemName: "list.bullet.clipboard")
                        Text("Decisions")
                    }
                    .tag(0)
                
                SearchView()
                    .environmentObject(viewModel)
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .tag(1)
                
                AddDecisionView(selectedTab: $selectedTab)
                    .environmentObject(viewModel)
                    .tabItem {
                        Image(systemName: "plus.circle.fill")
                        Text("Add")
                    }
                    .tag(2)
                
                AnalyticsView()
                    .environmentObject(viewModel)
                    .tabItem {
                        Image(systemName: "chart.bar")
                        Text("Analytics")
                    }
                    .tag(3)
                
                SettingsView()
                    .environmentObject(viewModel)
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
                    .tag(4)
            }
            .accentColor(DesignSystem.Colors.yellow)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(DecisionViewModel())
}
