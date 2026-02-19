import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppStateViewModel
    
    var body: some View {
        Group {
            if !appState.hasCompletedOnboarding {
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
        .environmentObject(AppStateViewModel())
}
