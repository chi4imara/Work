import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppStateManager
    
    var body: some View {
        ZStack {
            if appState.showOnboarding {
                OnboardingView()
            } else {
                MainTabView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppStateManager())
}
