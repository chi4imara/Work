import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = CosmeticsViewModel()
    @State private var selectedTab: TabItem = .catalog
    @State private var showingSplash = true
    @State private var showOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    
    var body: some View {
        ZStack {
            if !showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
                    .transition(.slide)
            } else {
                NavigationStack {
                    mainContent
                        .navigationBarHidden(true)
                }
                
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showingSplash = false
                }
            }
        }
    }
    
    private var mainContent: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .catalog:
                    CatalogView(viewModel: viewModel)
                case .categories:
                    CategoriesView(viewModel: viewModel) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = .catalog
                        }
                    }
                case .favorites:
                    FavoritesView(viewModel: viewModel)
                case .statistics:
                    StatisticsView(viewModel: viewModel)
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
    MainTabView()
}
