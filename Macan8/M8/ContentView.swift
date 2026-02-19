import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppStateViewModel
    
    var body: some View {
        ZStack {
             if appState.isFirstLaunch {
                OnboardingView(appState: appState)
            } else {
                MainTabView(appState: appState)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appState.isLoading)
        .animation(.easeInOut(duration: 0.5), value: appState.isFirstLaunch)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppStateViewModel())
}
