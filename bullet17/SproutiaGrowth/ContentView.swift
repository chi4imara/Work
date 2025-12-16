import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appStateManager: AppStateManager
    
    var body: some View {
        ZStack {
           if appStateManager.isShowingOnboarding {
                OnboardingView {
                    appStateManager.completeOnboarding()
                }
            } else {
                MainTabView()
            }
        }
        .background(Color(.systemBackground))
        .animation(.easeInOut(duration: 0.5), value: appStateManager.isShowingSplash)
        .animation(.easeInOut(duration: 0.5), value: appStateManager.isShowingOnboarding)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppStateManager())
        .environmentObject(DataManager.shared)
}
