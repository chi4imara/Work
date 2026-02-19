import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @State private var showOnboarding = false
    
    var body: some View {
        ZStack {
            if showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
            } else {
                NavigationStack {
                    MainTabView()
                        .navigationBarHidden(true)
                }
            }
        }
        .onAppear {
            checkOnboardingStatus()
        }
    }
    
    private func checkOnboardingStatus() {
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "HasCompletedOnboarding")
        if !hasCompletedOnboarding {
            showOnboarding = true
        }
    }
}

#Preview {
    ContentView()
}
