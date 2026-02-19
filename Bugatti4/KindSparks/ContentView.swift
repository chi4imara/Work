import SwiftUI

struct ContentView: View {
    @State private var isLoading = true
    @State private var showOnboarding = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
    
    var body: some View {
        Group {
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

#Preview {
    ContentView()
}
