import SwiftUI

struct ContentView: View {
    @StateObject private var appStateManager = AppStateManager()
    
    var body: some View {
        ZStack {
            if appStateManager.showOnboarding {
                OnboardingView(showOnboarding: $appStateManager.showOnboarding)
            } else {
                MainTabView()
            }
        }
        .preferredColorScheme(.dark)
        .onChange(of: appStateManager.showOnboarding) { newValue in
            if !newValue {
                appStateManager.completeOnboarding()
            }
        }
    }
}

#Preview {
    ContentView()
}
