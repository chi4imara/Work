import SwiftUI

struct MainTabView: View {
    @ObservedObject var appViewModel: AppViewModel
    @StateObject private var dictionaryViewModel = DictionaryViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        TabView(selection: $appViewModel.selectedTab) {
            DictionaryView(viewModel: dictionaryViewModel)
                .tabItem {
                    Image(systemName: TabItem.dictionary.iconName)
                    Text(TabItem.dictionary.title)
                }
                .tag(TabItem.dictionary)
            
            AllWordsView(viewModel: dictionaryViewModel)
                .tabItem {
                    Image(systemName: TabItem.all.iconName)
                    Text(TabItem.all.title)
                }
                .tag(TabItem.all)
            
            CalendarView(viewModel: dictionaryViewModel)
                .tabItem {
                    Image(systemName: TabItem.calendar.iconName)
                    Text(TabItem.calendar.title)
                }
                .tag(TabItem.calendar)
            
            StatisticsView(viewModel: dictionaryViewModel)
                .tabItem {
                    Image(systemName: TabItem.statistics.iconName)
                    Text(TabItem.statistics.title)
                }
                .tag(TabItem.statistics)
            
            SettingsView(viewModel: settingsViewModel)
                .tabItem {
                    Image(systemName: TabItem.settings.iconName)
                    Text(TabItem.settings.title)
                }
                .tag(TabItem.settings)
        }
        .accentColor(ColorManager.primaryBlue)
        .background(ColorManager.backgroundGradient)
    }
}

#Preview {
    MainTabView(appViewModel: AppViewModel())
}
