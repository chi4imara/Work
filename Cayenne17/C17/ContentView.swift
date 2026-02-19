import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: TabItem = .newPhase
    
    var body: some View {
        ZStack {
            if appState.isFirstLaunch {
                OnboardingView {
                    appState.completeOnboarding()
                }
            } else {
                mainAppView
            }
        }
        .onAppear {            
            if UserDefaults.standard.object(forKey: Constants.UserDefaultsKeys.isFirstLaunch) == nil {
                appState.isFirstLaunch = true
            } else {
                appState.isFirstLaunch = UserDefaults.standard.bool(forKey: Constants.UserDefaultsKeys.isFirstLaunch)
            }
        }
    }
    
    private var mainAppView: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .newPhase:
                    NewPhaseView()
                case .cycles:
                    CyclesView()
                case .results:
                    ResultsView()
                case .analytics:
                    AnalyticsView()
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
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
