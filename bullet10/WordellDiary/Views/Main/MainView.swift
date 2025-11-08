import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = DiaryViewModel()
    @State private var selectedTab: TabItem = .days
    @State private var showingFilters = false
    @State private var showingNewEntry = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .days:
                        DaysListView(viewModel: viewModel, showingNewEntry: $showingNewEntry)
                    case .newEntry:
                        NewEntryView(viewModel: viewModel, selectedTab: $selectedTab)
                    case .themes:
                        ThemesView(viewModel: viewModel, showingNewEntry: $showingNewEntry)
                    case .statistics:
                        StatisticsView(viewModel: viewModel)
                    case .settings:
                        SettingsView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .sheet(isPresented: $showingNewEntry) {
            NewEntryView(viewModel: viewModel, selectedTab: $selectedTab)
        }
        .onChange(of: selectedTab) { newValue in
            if newValue == .newEntry {
                showingNewEntry = true
                selectedTab = .days 
            }
        }
    }
}

#Preview {
    MainView()
}
