import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var dataManager: EmotionDataManager
    @State private var selectedTab: TabItem = .newEntry
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .newEntry:
                        NewEntryView(dataManager: dataManager) {
                            selectedTab = .archive
                        }
                    case .archive:
                        ArchiveView(dataManager: dataManager, selectedTab: $selectedTab)
                    case .calendar:
                        CalendarView(dataManager: dataManager)
                    case .statistics:
                        StatisticsView(dataManager: dataManager)
                    case .settings:
                        SettingsView(dataManager: dataManager)
                    }
                }
            }
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.bottom, 10)
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(EmotionDataManager())
}
