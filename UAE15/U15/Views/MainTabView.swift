import SwiftUI

struct MainTabView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var selectedTab: TabItem = .journal
    @State private var showingAddProcedure = false
    
    var body: some View {
        ZStack {
            ColorManager.shared.primaryBackground
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .journal:
                    JournalView(selectedTab: $selectedTab)
                        .environmentObject(dataManager)
                case .statistics:
                    StatisticsView()
                        .environmentObject(dataManager)
                case .add:
                    AddProcedureView(selectedTab: $selectedTab)
                        .environmentObject(dataManager)
                case .insights:
                    InsightsView()
                        .environmentObject(dataManager)
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .environmentObject(dataManager)
    }
}

#Preview {
    MainTabView()
}
