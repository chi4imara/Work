import SwiftUI

struct MainContainerView: View {
    @StateObject private var viewModel = ToolsViewModel()
    @State private var selectedTab: TabItem = .catalog
    @State private var showingSplash = true
    @State private var showingOnboarding = false
    
    var body: some View {
        ZStack {
            mainContent
                .fullScreenCover(isPresented: $showingOnboarding) {
                    OnboardingView(showOnboarding: $showingOnboarding)
                        .onDisappear {
                            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                        }
                }
        }
    }
    
    private var mainContent: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .catalog:
                    CatalogView(viewModel: viewModel)
                case .statistics:
                    StatisticsView(viewModel: viewModel)
                case .usage:
                    UsageHistoryView(viewModel: viewModel)
                case .extra:
                    QuickActionsView(viewModel: viewModel, selectedTab: $selectedTab)
                case .settings:
                    SettingsView()
                }
            }
            
            VStack(spacing: 0) {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
    
    private var hasSeenOnboarding: Bool {
        UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    }
}

#Preview {
    MainContainerView()
}
