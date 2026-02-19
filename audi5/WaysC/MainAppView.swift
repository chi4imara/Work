import SwiftUI

struct MainAppView: View {
    @StateObject private var viewModel = BagViewModel()
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            if viewModel.showOnboarding {
                OnboardingView(viewModel: viewModel)
            } else {
                NavigationStack {
                    MainTabView(viewModel: viewModel)
                        .navigationBarHidden(true)
                }
            }
        }
    }
}

struct MainTabView: View {
    @ObservedObject var viewModel: BagViewModel
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch viewModel.selectedTab {
                case .home:
                    HomeView(viewModel: viewModel)
                case .scenarios:
                    ScenariosView(viewModel: viewModel)
                case .favorites:
                    FavoritesView(viewModel: viewModel)
                case .statistics:
                    StatisticsView(viewModel: viewModel)
                case .settings:
                    SettingsView(viewModel: viewModel)
                }
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $viewModel.selectedTab)
            }
        }
    }
}

#Preview {
    MainAppView()
}
