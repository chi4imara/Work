import SwiftUI

struct AppRootView: View {
    @State private var showSplash = true
    @State private var showOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    
    var body: some View {
        ZStack {
            if !showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
            } else {
                NavigationStack {
                    MainTabView()
                        .navigationBarHidden(true)
                }
            }
        }
    }
}
