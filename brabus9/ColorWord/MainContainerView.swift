import SwiftUI

struct MainContainerView: View {
    @StateObject private var appViewModel = AppViewModel()
    @StateObject private var catalogViewModel = CatalogViewModel()
    
    var body: some View {
        ZStack {
            if catalogViewModel.isFirstLaunch {
                OnboardingView(catalogViewModel: catalogViewModel)
                    .transition(.slide)
            } else {
                NavigationStack {
                    MainTabView(
                        appViewModel: appViewModel,
                        catalogViewModel: catalogViewModel
                    )
                    .transition(.slide)
                    .navigationBarHidden(true)
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appViewModel.showSplash)
        .animation(.easeInOut(duration: 0.5), value: catalogViewModel.isFirstLaunch)
        .onAppear {
            appViewModel.hideSplash()
        }
    }
}

struct MainTabView: View {
    @ObservedObject var appViewModel: AppViewModel
    @ObservedObject var catalogViewModel: CatalogViewModel
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            Group {
                switch appViewModel.selectedTab {
                case .catalog:
                    CatalogView(viewModel: catalogViewModel)
                case .random:
                    RandomView(viewModel: catalogViewModel)
                case .calendar:
                    CalendarView(catalogViewModel: catalogViewModel)
                case .statistics:
                    StatisticsView(catalogViewModel: catalogViewModel)
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $appViewModel.selectedTab)
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    MainContainerView()
}
