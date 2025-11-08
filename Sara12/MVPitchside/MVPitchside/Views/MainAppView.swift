import SwiftUI

struct MainAppView: View {
    @StateObject private var matchViewModel = MatchViewModel()
    @StateObject private var tournamentViewModel = TournamentViewModel()
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    
    @State private var showSplash = true
    @State private var selectedTab: TabItem = .matches
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashScreenView {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showSplash = false
                    }
                }
            } else if !onboardingViewModel.hasSeenOnboarding {
                OnboardingView(viewModel: onboardingViewModel) {
                }
            } else {
                mainContentView
            }
        }
    }
    
    private var mainContentView: some View {
        ZStack {
            AppGradient.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch selectedTab {
                    case .matches:
                        MatchesView(viewModel: matchViewModel)
                    case .tournaments:
                        TournamentsView(viewModel: tournamentViewModel)
                    case .statistics:
                        StatisticsView(viewModel: matchViewModel)
                    case .players:
                        PlayersView(viewModel: matchViewModel)
                    case .settings:
                        SettingsView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            VStack {
                Spacer()
                
                CustomTabBar(
                    selectedTab: $selectedTab,
                    tabs: TabItem.allCases
                )
            }
        }
    }
}

#Preview {
    MainAppView()
}
