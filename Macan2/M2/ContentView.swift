import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppStateViewModel
    
    var body: some View {
        ZStack {
         if appState.showingOnboarding {
                OnboardingView {
                    appState.completeOnboarding()
                }
            } else {
                MainTabView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppStateViewModel())
}
