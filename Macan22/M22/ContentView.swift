import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @State private var showOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    var body: some View {
        ZStack {
            if !showOnboarding {
                OnboardingView(isCompleted: $showOnboarding)
            } else {
                NavigationStack {
                    MainTabView()
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
