import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @State private var showOnboarding = UserDefaults.standard.bool(forKey: "HasOnboardingCompleted")
    
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
    
    private func isFirstLaunch() -> Bool {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if !hasLaunchedBefore {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            return true
        }
        return false
    }
}

#Preview {
    ContentView()
}
