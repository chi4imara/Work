import SwiftUI

struct MainAppView: View {
    @StateObject private var viewModel = AppViewModel()
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            if viewModel.showOnboarding {
                OnboardingView(viewModel: viewModel)
                    .transition(.opacity)
            } else {
                NavigationStack {
                    MainTabView(viewModel: viewModel)
                        .transition(.opacity)
                        .navigationBarHidden(true)
                }
            }
        }
    }
}

struct MainTabView: View {
    @ObservedObject var viewModel: AppViewModel
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ZStack {
            BackgroundView()
                .ignoresSafeArea()
            
            Group {
                switch viewModel.currentTab {
                case .today:
                    TodayView(viewModel: viewModel)
                case .habits:
                    HabitsView(viewModel: viewModel)
                case .history:
                    HistoryView(viewModel: viewModel)
                case .statistics:
                    StatisticsView(viewModel: viewModel)
                case .settings:
                    SettingsView(viewModel: viewModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $viewModel.currentTab)
            }
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .background, .inactive:
                viewModel.saveAllData()
            case .active:
                viewModel.loadAllData()
            @unknown default:
                break
            }
        }
    }
}

#Preview {
    MainAppView()
}
