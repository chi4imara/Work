import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @State private var showOnboarding = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        ZStack {
            if !hasSeenOnboarding {
                OnboardingView(showOnboarding: $hasSeenOnboarding)
            } else {
                NavigationStack {
                    MainTabView()
                        .navigationBarHidden(true)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
