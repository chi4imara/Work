import SwiftUI

struct ContentView: View {
    @State private var showingSplash = true
    @State private var showingOnboarding = false
    @State private var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    var body: some View {
        Group {
       if !hasCompletedOnboarding {
                OnboardingView {
                    hasCompletedOnboarding = true
                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                    showingOnboarding = false
                }
            } else {
                MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showingSplash)
        .animation(.easeInOut(duration: 0.5), value: showingOnboarding)
    }
}

#Preview {
    ContentView()
}
