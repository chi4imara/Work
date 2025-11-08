import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var appState = AppState()
    
    var body: some View {
        Group {
            switch appState.currentState {
            case .onboarding:
                OnboardingView {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        appState.currentState = .main
                        appState.completeOnboarding()
                    }
                }
                
            case .main:
                MainTabView()
            }
        }
    }
}

class AppState: ObservableObject {
    @Published var currentState: AppStateType
    
    init() {
        let hasCompleted = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        print("🚀 AppState init - hasCompletedOnboarding: \(hasCompleted)")
        
        if hasCompleted {
            self.currentState = .main
        } else {
            self.currentState = .onboarding
        }
    }
    
    var hasCompletedOnboarding: Bool {
        UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
}

enum AppStateType {
    case onboarding
    case main
}

struct MainTabView: View {
    @StateObject private var store = FirstExperienceStore()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MainFeedView(store: store)
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "list.bullet.circle.fill" : "list.bullet.circle")
                        .font(.system(size: 24))
                    Text("Feed")
                        .font(FontManager.tabBarText)
                }
                .tag(0)
            
            CategoriesView(store: store)
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "tag.fill" : "tag")
                        .font(.system(size: 24))
                    Text("Categories")
                        .font(FontManager.tabBarText)
                }
                .tag(1)
            
            StatisticsView(store: store, selectedTabStat: $selectedTab)
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "chart.bar.fill" : "chart.bar")
                        .font(.system(size: 24))
                    Text("Statistics")
                        .font(FontManager.tabBarText)
                }
                .tag(2)
            
            InsightsView(store: store)
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "lightbulb.fill" : "lightbulb")
                        .font(.system(size: 24))
                    Text("Insights")
                        .font(FontManager.tabBarText)
                }
                .tag(3)
            
            CreativeSettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                        .font(.system(size: 24))
                    Text("Settings")
                        .font(FontManager.tabBarText)
                }
                .tag(4)
        }
        .accentColor(AppColors.accentYellow)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        
        appearance.backgroundColor = UIColor(AppColors.primaryBlue.opacity(0.1))
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.black)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.black),
            .font: UIFont.systemFont(ofSize: 10, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.accentYellow)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.pureWhite),
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    ContentView()
}
