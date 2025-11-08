import SwiftUI

enum AppState {
    case onboarding
    case main
}

struct MainAppView: View {
    @State private var appState: AppState = .onboarding
    @State private var selectedTab: TabItem = .list
    @StateObject private var movieListViewModel = MovieListViewModel()
    
    private let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    
    var body: some View {
        ZStack {
            switch appState {
            case .onboarding:
                OnboardingView {
                    UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                    withAnimation(.easeInOut(duration: 0.5)) {
                        appState = .main
                    }
                }
                
            case .main:
                MainTabView(
                    selectedTab: $selectedTab,
                    movieListViewModel: movieListViewModel
                )
            }
        }
        .preferredColorScheme(.light)
    }
}

struct MainTabView: View {
    @Binding var selectedTab: TabItem
    let movieListViewModel: MovieListViewModel
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .list:
                    MovieListView()
                        .environmentObject(movieListViewModel)
                        
                case .collections:
                    CollectionsView()
                        .environmentObject(movieListViewModel)
                    
                case .progress:
                    ProgressView(movieListViewModel: movieListViewModel)
                    
                case .settings:
                    SettingsView(viewModel: movieListViewModel)
                }
            }
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    MainAppView()
}
