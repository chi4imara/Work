import SwiftUI

struct MainTabView: View {
    @ObservedObject var viewModel: GratitudeViewModel
    @State private var selectedTab: TabSelection = .calendar
    @State private var activeSheet: SheetIdentifier?
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CalendarView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: TabSelection.calendar.systemImage)
                    Text(TabSelection.calendar.title)
                }
                .tag(TabSelection.calendar)
            
            HistoryView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: TabSelection.history.systemImage)
                    Text(TabSelection.history.title)
                }
                .tag(TabSelection.history)
            
            StatisticsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: TabSelection.statistics.systemImage)
                    Text(TabSelection.statistics.title)
                }
                .tag(TabSelection.statistics)
            
            SettingsView()
                .tabItem {
                    Image(systemName: TabSelection.settings.systemImage)
                    Text(TabSelection.settings.title)
                }
                .tag(TabSelection.settings)
        }
        .accentColor(.accentBlue)
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .gratitudeEntry(let date):
                GratitudeEntryView(viewModel: viewModel, date: date)
            case .gratitudeDetail(let date):
                GratitudeDetailView(viewModel: viewModel, date: date)
            case .editEntry(let date):
                GratitudeEntryView(viewModel: viewModel, date: date)
            case .menu:
                EmptyView()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .showGratitudeEntry)) { notification in
            if let date = notification.object as? Date {
                activeSheet = .gratitudeEntry(date: date)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .showGratitudeDetail)) { notification in
            if let date = notification.object as? Date {
                activeSheet = .gratitudeDetail(date: date)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .switchToHistoryTab)) { _ in
            selectedTab = .history
        }
        .onReceive(NotificationCenter.default.publisher(for: .switchToStatisticsTab)) { _ in
            selectedTab = .statistics
        }
    }
}

extension Notification.Name {
    static let showGratitudeEntry = Notification.Name("showGratitudeEntry")
    static let showGratitudeDetail = Notification.Name("showGratitudeDetail")
    static let switchToHistoryTab = Notification.Name("switchToHistoryTab")
    static let switchToStatisticsTab = Notification.Name("switchToStatisticsTab")
}
