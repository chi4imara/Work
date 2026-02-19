import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppStateManager
    
    var body: some View {
        ZStack {
            if appState.isFirstLaunch {
                OnboardingView(appState: appState)
            } else {
                NavigationStack {
                    MainTabView()
                        .navigationBarHidden(true)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppStateManager())
}
