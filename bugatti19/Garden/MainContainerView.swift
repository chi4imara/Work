import SwiftUI

struct MainContainerView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject private var appViewModel = AppViewModel()
    @StateObject private var todayViewModel = TodayViewModel()
    @StateObject private var habitsViewModel = HabitsViewModel()
    @StateObject private var historyViewModel = HistoryViewModel()
    
    @State private var selectedTab: TabItem = .today
    
    var body: some View {
        ZStack {
            if !appViewModel.hasCompletedOnboarding {
                OnboardingView {
                    appViewModel.completeOnboarding()
                }
                .transition(.slide)
            } else {
                NavigationStack {
                    mainAppView
                        .transition(.opacity)
                        .navigationBarHidden(true)
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appViewModel.showSplashScreen)
        .animation(.easeInOut(duration: 0.5), value: appViewModel.hasCompletedOnboarding)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background || newPhase == .inactive {
                DispatchQueue.main.async {
                    saveAppData()
                }
            }
        }
    }
    
    private func saveAppData() {
        let calendar = Calendar.current
        let today = todayViewModel.todayProgress
        var history = historyViewModel.dailyProgressHistory
        if let idx = history.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: today.date) }) {
            history[idx] = today
        } else {
            history.insert(today, at: 0)
        }
        let data = AppPersistedData(
            todayProgress: today,
            dailyChallenge: todayViewModel.dailyChallenge,
            habits: habitsViewModel.habits,
            dailyProgressHistory: history
        )
        PersistenceManager.save(data)
    }
    
    private func loadSampleData() {
        DispatchQueue.main.async {
            self.todayViewModel.loadSampleData()
            self.habitsViewModel.loadSampleData()
            self.historyViewModel.loadSampleData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.saveAppData()
            }
        }
    }
    
    private var mainAppView: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ZStack {
                    switch selectedTab {
                    case .today:
                        TodayView(
                            viewModel: todayViewModel,
                            historyViewModel: historyViewModel
                        )
                    case .habits:
                        HabitsView(viewModel: habitsViewModel)
                    case .statistics:
                        StatisticsView(
                            historyViewModel: historyViewModel,
                            habitsViewModel: habitsViewModel
                        )
                    case .history:
                        HistoryView(viewModel: historyViewModel)
                    case .settings:
                        SettingsView(onLoadSampleData: loadSampleData)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    MainContainerView()
}
