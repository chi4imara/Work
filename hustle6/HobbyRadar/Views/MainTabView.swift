import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .home
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(TabItem.home)
                
                AllIdeasView()
                    .tag(TabItem.allIdeas)
                
                FavoritesView()
                    .tag(TabItem.favorites)
                
                SettingsView()
                    .tag(TabItem.settings)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

struct AppRootView: View {
    @State private var appState: AppState = .onboarding
    @State private var hasSeenOnboarding = UserDefaults.standard.bool(forKey: "HasSeenOnboarding")
    
    var body: some View {
        Group {
            switch appState {
            case .onboarding:
                OnboardingView {
                    UserDefaults.standard.set(true, forKey: "HasSeenOnboarding")
                    withAnimation(.easeInOut(duration: 0.5)) {
                        appState = .main
                    }
                }
                
            case .main:
                MainTabView()
            }
        }
        .onAppear {
            FontManager.shared.registerFonts()
        }
    }
}

enum AppState {
    case onboarding
    case main
}

#Preview {
    AppRootView()
}
