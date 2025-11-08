import SwiftUI

struct MainAppView: View {
    @StateObject private var memoryStore = MemoryStore()
    @State private var selectedTab: TabItem = .memories
    @State private var selectedMemory: Memory?
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .memories:
                        MemoriesListView(memoryStore: memoryStore)
                    case .calendar:
                        CalendarView(memoryStore: memoryStore)
                    case .statistics:
                        StatisticsView(memoryStore: memoryStore)
                    case .settings:
                        SettingsView()
                    }
                }
            }
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .sheet(item: $selectedMemory) { memory in
            NavigationView {
                MemoryDetailView(memoryStore: memoryStore, memory: memory)
            }
        }
    }
}

#Preview {
    MainAppView()
}
