import SwiftUI

struct MainTabView: View {
    @StateObject private var journalViewModel = RepotJournalViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            RepotJournalView()
                .environmentObject(journalViewModel)
                .tabItem {
                    Image(systemName: "book")
                    Text("Journal")
                }
                .tag(0)
            
            PlantsListView(
                journalViewModel: journalViewModel,
                onPlantSelected: { plantName in
                    journalViewModel.selectedPlant = plantName
                    journalViewModel.selectedPeriod = .all
                    selectedTab = 0
                }
            )
            .tabItem {
                Image(systemName: "leaf")
                Text("Plants")
            }
            .tag(1)
            
            DashboardView(journalViewModel: journalViewModel, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Dashboard")
                }
                .tag(2)
            
            QuickActionsView(journalViewModel: journalViewModel, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "bolt.circle.fill")
                    Text("Quick")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(AppColors.primaryBlue)
    }
}


#Preview {
    MainTabView()
}
