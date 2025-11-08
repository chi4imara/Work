import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = GiftIdeaViewModel()
    
    var body: some View {
        TabView {
            GiftIdeasView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "gift")
                    Text("Ideas")
                }
            
            PeopleView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "person.2")
                    Text("People")
                }
            
            SearchView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            AnalyticsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Analytics")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
        .accentColor(Color.theme.primaryBlue)
    }
}

#Preview {
    MainTabView()
}
