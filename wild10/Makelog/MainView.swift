import SwiftUI

struct MainView: View {
    @StateObject private var weatherEntriesViewModel = WeatherEntriesViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            Group {
                switch selectedTab {
                case 0:
                    NavigationStack {
                        EntriesView(viewModel: weatherEntriesViewModel)
                            .navigationBarHidden(true)
                    }
                case 1:
                    NavigationStack {
                        CategoriesView(viewModel: weatherEntriesViewModel, selectedTab: $selectedTab)
                            .navigationBarHidden(true)
                    }
                case 2:
                    NavigationStack {
                        TimelineView(viewModel: weatherEntriesViewModel, selectedTab: $selectedTab)
                            .navigationBarHidden(true)
                    }
                case 3:
                    NavigationStack {
                        AddEntryView(
                            weatherEntriesViewModel: weatherEntriesViewModel,
                            selectedTab: $selectedTab
                        )
                        .navigationBarHidden(true)
                    }
                case 4:
                    NavigationStack {
                        SettingsView()
                            .navigationBarHidden(true)
                    }
                default:
                    NavigationStack {
                        EntriesView(viewModel: weatherEntriesViewModel)
                            .navigationBarHidden(true)
                    }
                }
            }
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .sheet(isPresented: $weatherEntriesViewModel.isShowingCreateEntry) {
            CreateEntryView(
                viewModel: CreateEntryViewModel(
                    weatherEntriesViewModel: weatherEntriesViewModel,
                    editingEntry: weatherEntriesViewModel.editingEntry
                )
            )
        }
    }
}

#Preview {
    MainView()
}
