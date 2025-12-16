import SwiftUI

struct MainTabView: View {
    @StateObject private var dataManager = MoodDataManager()
    @State private var selectedTab = 0
    @State private var sheetItem: SheetItem?
    
    enum SheetItem: Identifiable {
        case moodEntry(date: Date, entry: MoodEntry?)
        
        var id: String {
            switch self {
            case .moodEntry(let date, let entry):
                return "moodEntry_\(date.timeIntervalSince1970)_\(entry?.id.uuidString ?? "new")"
            }
        }
    }
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case 0:
                    CalendarView(dataManager: dataManager, selectedTab: $selectedTab)
                case 1:
                    AddMood(
                        dataManager: dataManager,
                        selectedDate: Date(),
                        entryToEdit: nil,
                        onSave: {
                            withAnimation {
                                selectedTab = 0
                            }
                        }
                    )
                case 2:
                    HistoryView(dataManager: dataManager)
                case 3:
                    StatisticsView(dataManager: dataManager)
                case 4:
                    SettingsView()
                default:
                    CalendarView(dataManager: dataManager, selectedTab: $selectedTab)
                }
            }
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .sheet(item: $sheetItem) { item in
            switch item {
            case .moodEntry(let date, let entry):
                MoodEntryView(
                    dataManager: dataManager,
                    selectedDate: date,
                    entryToEdit: entry
                )
            }
        }
    }
}

#Preview {
    MainTabView()
}
