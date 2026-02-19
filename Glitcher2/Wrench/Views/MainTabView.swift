import SwiftUI

struct MainTabView: View {
    @StateObject private var projectViewModel = ProjectViewModel()
    
    var body: some View {
        TabView {
            NewProjectView(viewModel: projectViewModel)
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Project")
                }
                .tag(0)
            
            ProjectListView(viewModel: projectViewModel)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("List")
                }
                .tag(1)
            
            CategoriesView(viewModel: projectViewModel)
                .tabItem {
                    Image(systemName: "tag")
                    Text("Categories")
                }
                .tag(2)
            
            StatisticsView(viewModel: projectViewModel)
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Statistics")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(ColorManager.lightBlue)
    }
}

#Preview {
    MainTabView()
}
