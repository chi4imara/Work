import SwiftUI

struct MainAppView: View {
    @StateObject private var appViewModel = AppViewModel()
    @StateObject private var momentsViewModel = DailyMomentsViewModel()
    @StateObject private var notesViewModel = NotesViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        ZStack {
            if !appViewModel.hasCompletedOnboarding {
                OnboardingView {
                    appViewModel.completeOnboarding()
                }
            } else
            
            {
                mainTabView
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appViewModel.appState)
    }
    
    private var mainTabView: some View {
        ZStack {
            AppGradients.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch appViewModel.selectedTab {
                    case .home:
                        HomeView(momentsViewModel: momentsViewModel, selectedTab: $appViewModel.selectedTab)
                    case .history:
                        HistoryView(momentsViewModel: momentsViewModel)
                    case .notes:
                        NotesView(notesViewModel: notesViewModel)
                    case .statistics:
                        StatisticsView(
                            profileViewModel: profileViewModel,
                            momentsViewModel: momentsViewModel
                        )
                    case .settings:
                        SettingsView(settingsViewModel: settingsViewModel)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $appViewModel.selectedTab)
            }
        }
    }
}

#Preview {
    MainAppView()
}
