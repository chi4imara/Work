import SwiftUI

struct ContentView: View {
    @State private var showingSplash = true
    @State private var hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    
    var body: some View {
        Group {
            if !hasSeenOnboarding {
                OnboardingView(isComplete: $hasSeenOnboarding)
            } else {
                MainTabView()
            }
        }
    }
}

#Preview {
    ContentView()
}
