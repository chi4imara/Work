import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @State private var showOnboarding = UserDefaults.standard.bool(forKey: "HasOnboardingCompleted")
    
    var body: some View {
        ZStack {
            if !showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
                    .transition(.opacity)
            } else {
                NavigationStack {
                    MainTabView()
                        .transition(.opacity)
                        .navigationBarHidden(true)
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showSplash)
        .animation(.easeInOut(duration: 0.5), value: showOnboarding)
    }
}

#Preview {
    ContentView()
}
