import SwiftUI

struct MainTabView: View {
    @StateObject private var programsViewModel = ProgramsViewModel()
    @State private var selectedTab: TabItem = .timer
    
    var body: some View {
        ZStack {
            VStack {
                Group {
                    switch selectedTab {
                    case .timer:
                        TimerView(programsViewModel: programsViewModel, selectedTab: $selectedTab)
                    case .programs:
                        ProgramsView(programsViewModel: programsViewModel)
                    case .history:
                        HistoryView()
                    case .settings:
                        SettingsView()
                    case .extra:
                        ExtraView()
                    }
                }
            }
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .onAppear {
            programsViewModel.loadPrograms()
        }
    }
}

#Preview {
    MainTabView()
}
