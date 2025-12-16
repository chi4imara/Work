import SwiftUI

struct MainTabView: View {
    @ObservedObject var viewModel: MainAppViewModel
    
    var body: some View {
        Group {
            TabView(selection: $viewModel.selectedTab) {
                CombinationsView(viewModel: viewModel.scentCombinationsViewModel)
                    .tabItem {
                        Image(systemName: viewModel.selectedTab == .combinations ?
                              TabSelection.combinations.selectedIcon :
                                TabSelection.combinations.icon)
                        Text(TabSelection.combinations.rawValue)
                    }
                    .tag(TabSelection.combinations)
                
                CategoriesView(
                    viewModel: viewModel.categoriesViewModel,
                    combinationsViewModel: viewModel.scentCombinationsViewModel,
                    selectedTab: $viewModel.selectedTab
                )
                .tabItem {
                    Image(systemName: viewModel.selectedTab == .categories ?
                          TabSelection.categories.selectedIcon :
                            TabSelection.categories.icon)
                    Text(TabSelection.categories.rawValue)
                }
                .tag(TabSelection.categories)
                
                NotesView(viewModel: viewModel.notesViewModel)
                    .tabItem {
                        Image(systemName: viewModel.selectedTab == .notes ?
                              TabSelection.notes.selectedIcon :
                                TabSelection.notes.icon)
                        Text(TabSelection.notes.rawValue)
                    }
                    .tag(TabSelection.notes)
                
                StatisticsView(
                    combinationsViewModel: viewModel.scentCombinationsViewModel,
                    notesViewModel: viewModel.notesViewModel
                )
                .tabItem {
                    Image(systemName: viewModel.selectedTab == .statistics ?
                          TabSelection.statistics.selectedIcon :
                            TabSelection.statistics.icon)
                    Text(TabSelection.statistics.rawValue)
                }
                .tag(TabSelection.statistics)
                
                SettingsView(viewModel: viewModel.settingsViewModel)
                    .tabItem {
                        Image(systemName: viewModel.selectedTab == .settings ?
                              TabSelection.settings.selectedIcon :
                                TabSelection.settings.icon)
                        Text(TabSelection.settings.rawValue)
                    }
                    .tag(TabSelection.settings)
            }
            .accentColor(AppColors.purpleGradientStart)
        }
    }
}

#Preview {
    MainTabView(viewModel: MainAppViewModel())
}
