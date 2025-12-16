import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppStateManager()
    @State private var splashTimer: Timer?
    
    var body: some View {
        Group {
            if !appState.hasCompletedOnboarding {
                OnboardingView(appState: appState)
            } else {
                MainTabView()
            }
        }
        .onDisappear {
            splashTimer?.invalidate()
        }
    }
}

#Preview {
    ContentView()
}
