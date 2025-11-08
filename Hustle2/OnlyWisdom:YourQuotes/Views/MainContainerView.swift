import SwiftUI

struct MainContainerView: View {
    @StateObject private var quoteStore = QuoteStore()
    @StateObject private var appState = AppStateManager()
    
    var body: some View {
        Group {
            switch appState.currentView {
            case .onboarding:
                OnboardingView {
                    appState.completeOnboarding()
                }
            case .main:
                mainAppView
            }
        }
        .environmentObject(quoteStore)
        .animation(.easeInOut(duration: 0.5), value: appState.currentView)
    }
    
    private var mainAppView: some View {
        ZStack {
            Color.clear
                .backgroundGradient()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch appState.selectedTab {
                    case .feed:
                        NavigationView {
                            FeedView(quoteStore: quoteStore)
                        }
                    case .categories:
                        NavigationView {
                            CategoriesView(quoteStore: quoteStore)
                        }
                    case .statistics:
                        NavigationView {
                            StatisticsView(quoteStore: quoteStore)
                        }
                    case .archive:
                        NavigationView {
                            ArchiveView(quoteStore: quoteStore)
                        }
                    case .settings:
                        NavigationView {
                            SettingsView()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Spacer(minLength: 0)
            }
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $appState.selectedTab)
            }
        }
    }
}

class AppStateManager: ObservableObject {
    @Published var currentView: AppView = .onboarding
    @Published var selectedTab: TabItem = .feed
    
    private let hasSeenOnboardingKey = "hasSeenOnboarding"
    
    enum AppView {
        case onboarding
        case main
    }
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.checkInitialState()
        }
    }
    
    private func checkInitialState() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: hasSeenOnboardingKey)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if hasSeenOnboarding {
                self.currentView = .main
            } else {
                self.currentView = .onboarding
            }
        }
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: hasSeenOnboardingKey)
        currentView = .main
    }
    
    func resetOnboarding() {
        UserDefaults.standard.set(false, forKey: hasSeenOnboardingKey)
        currentView = .onboarding
    }
}

class NavigationCoordinator: ObservableObject {
    @Published var feedPath = NavigationPath()
    @Published var categoriesPath = NavigationPath()
    @Published var statisticsPath = NavigationPath()
    @Published var archivePath = NavigationPath()
    @Published var settingsPath = NavigationPath()
    
    func navigateToQuoteDetail(_ quote: Quote, from tab: TabItem) {
        switch tab {
        case .feed:
            feedPath.append(quote)
        case .categories:
            categoriesPath.append(quote)
        case .statistics:
            statisticsPath.append(quote)
        case .archive:
            archivePath.append(quote)
        case .settings:
            break
        }
    }
    
    func navigateToAddQuote(from tab: TabItem) {
    }
    
    func navigateToEditQuote(_ quote: Quote, from tab: TabItem) {
    }
    
    func navigateToCategoryQuotes(_ categoryName: String) {
        categoriesPath.append(categoryName)
    }
    
    func popToRoot(for tab: TabItem) {
        switch tab {
        case .feed:
            feedPath = NavigationPath()
        case .categories:
            categoriesPath = NavigationPath()
        case .statistics:
            statisticsPath = NavigationPath()
        case .archive:
            archivePath = NavigationPath()
        case .settings:
            settingsPath = NavigationPath()
        }
    }
}

struct EnhancedMainContainerView: View {
    @StateObject private var quoteStore = QuoteStore()
    @StateObject private var appState = AppStateManager()
    @StateObject private var navigationCoordinator = NavigationCoordinator()
    
    var body: some View {
        Group {
            switch appState.currentView {
            case .onboarding:
                OnboardingView {
                    appState.completeOnboarding()
                }
            case .main:
                mainAppView
            }
        }
        .environmentObject(quoteStore)
        .environmentObject(navigationCoordinator)
        .animation(.easeInOut(duration: 0.5), value: appState.currentView)
    }
    
    private var mainAppView: some View {
        ZStack {
            Color.clear
                .backgroundGradient()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Group {
                    switch appState.selectedTab {
                    case .feed:
                        NavigationStack(path: $navigationCoordinator.feedPath) {
                            FeedView(quoteStore: quoteStore)
                                .navigationDestination(for: Quote.self) { quote in
                                    QuoteDetailView(quoteStore: quoteStore, quote: quote)
                                }
                        }
                    case .categories:
                        NavigationStack(path: $navigationCoordinator.categoriesPath) {
                            CategoriesView(quoteStore: quoteStore)
                                .navigationDestination(for: String.self) { categoryName in
                                    CategoryQuotesView(quoteStore: quoteStore, categoryName: categoryName)
                                }
                                .navigationDestination(for: Quote.self) { quote in
                                    QuoteDetailView(quoteStore: quoteStore, quote: quote)
                                }
                        }
                    case .statistics:
                        NavigationStack(path: $navigationCoordinator.statisticsPath) {
                            StatisticsView(quoteStore: quoteStore)
                        }
                    case .archive:
                        NavigationStack(path: $navigationCoordinator.archivePath) {
                            ArchiveView(quoteStore: quoteStore)
                                .navigationDestination(for: Quote.self) { quote in
                                    QuoteDetailView(quoteStore: quoteStore, quote: quote)
                                }
                        }
                    case .settings:
                        NavigationStack(path: $navigationCoordinator.settingsPath) {
                            SettingsView()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Spacer(minLength: 0)
                
                CustomTabBar(selectedTab: $appState.selectedTab)
                    .onTapGesture {
                        navigationCoordinator.popToRoot(for: appState.selectedTab)
                    }
            }
        }
    }
}

#Preview {
    MainContainerView()
}
