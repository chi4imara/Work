import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            if !appState.isOnboardingCompleted {
                OnboardingView()
            } else {
                MainTabView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
