import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .journal
    @State private var showingSplash = true
    @State private var isOnboardingComplete = UserDefaults.standard.bool(forKey: "OnboardingComplete")
    
    var body: some View {
        ZStack {
        if !isOnboardingComplete {
                OnboardingView(isOnboardingComplete: $isOnboardingComplete)
                    .onAppear {
                        UserDefaults.standard.set(true, forKey: "OnboardingComplete")
                    }
            } else {
                mainContentView
            }
        }
    }
    
    private var mainContentView: some View {
        ZStack {
            AnimatedBackground()
            
                Group {
                    switch selectedTab {
                    case .journal:
                        JournalView()
                    case .products:
                        ProductsView()
                    case .analytics:
                        AnalyticsView()
                    case .tips:
                        TipsView()
                    case .settings:
                        SettingsView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
                
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    MainTabView()
}
