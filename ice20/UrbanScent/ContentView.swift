import SwiftUI

struct ContentView: View {
    @StateObject private var appStateViewModel = AppStateViewModel()
    
    var body: some View {
        ZStack {
           if appStateViewModel.showOnboarding {
                OnboardingView {
                    appStateViewModel.completeOnboarding()
                }
            } else {
                MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appStateViewModel.showSplash)
        .animation(.easeInOut(duration: 0.5), value: appStateViewModel.showOnboarding)
    }
}

#Preview {
    ContentView()
}
