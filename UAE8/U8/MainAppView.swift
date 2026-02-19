import SwiftUI

struct MainAppView: View {
    @StateObject private var workoutViewModel = WorkoutViewModel()
    @State private var selectedTab: TabItem = .week
    @State private var showingSplash = true
    @State private var showingOnboarding = false
    
    var body: some View {
        ZStack {
            if !workoutViewModel.hasCompletedOnboarding {
                OnboardingView(viewModel: workoutViewModel)
            } else {
                mainContent
            }
        }
    }
    
    private var mainContent: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .week:
                    WeekView(viewModel: workoutViewModel)
                case .categories:
                    CategoriesView(viewModel: workoutViewModel)
                case .history:
                    HistoryView(viewModel: workoutViewModel)
                case .statistics:
                    StatisticsView(viewModel: workoutViewModel)
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
    MainAppView()
}
