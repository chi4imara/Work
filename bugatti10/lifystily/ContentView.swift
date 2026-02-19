import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppStateViewModel()
    
    var body: some View {
        ZStack {
            if !appState.hasCompletedOnboarding {
                OnboardingView()
                    .environmentObject(appState)
            } else {
                NavigationStack {
                    MainTabView()
                        .navigationBarHidden(true)
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appState.isLoading)
        .animation(.easeInOut(duration: 0.5), value: appState.hasCompletedOnboarding)
    }
}

#Preview {
    ContentView()
}
