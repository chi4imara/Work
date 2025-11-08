import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()
    @StateObject private var store = CollectionStore()
    
    var body: some View {
        Group {
           if !appState.hasSeenOnboarding {
                OnboardingView(appState: appState)
            } else {
                MainTabView(appState: appState, store: store)
            }
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
