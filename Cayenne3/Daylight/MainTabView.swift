import SwiftUI

struct MainTabView: View {
    @ObservedObject var viewModel: TaskViewModel
    @State private var selectedTab: TabItem = .tasks
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TasksView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: selectedTab == .tasks ? TabItem.tasks.selectedIcon : TabItem.tasks.icon)
                    Text(TabItem.tasks.rawValue)
                }
                .tag(TabItem.tasks)
            
            CategoriesView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: selectedTab == .categories ? TabItem.categories.selectedIcon : TabItem.categories.icon)
                    Text(TabItem.categories.rawValue)
                }
                .tag(TabItem.categories)
            
            NotesView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: selectedTab == .notes ? TabItem.notes.selectedIcon : TabItem.notes.icon)
                    Text(TabItem.notes.rawValue)
                }
                .tag(TabItem.notes)
            
            StatisticsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: selectedTab == .statistics ? TabItem.statistics.selectedIcon : TabItem.statistics.icon)
                    Text(TabItem.statistics.rawValue)
                }
                .tag(TabItem.statistics)
            
            SettingsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: selectedTab == .settings ? TabItem.settings.selectedIcon : TabItem.settings.icon)
                    Text(TabItem.settings.rawValue)
                }
                .tag(TabItem.settings)
        }
        .accentColor(AppColors.lightBlue)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MainTabView(viewModel: TaskViewModel())
}
