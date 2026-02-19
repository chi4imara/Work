import SwiftUI

struct ContentView: View {
    @StateObject private var appStateManager = AppStateManager()
    
    var body: some View {
        ZStack {
            switch appStateManager.hasCompletedOnboarding {
            case false:
                OnboardingView(appStateManager: appStateManager)
                
            case true:
                NavigationStack {
                    MainTabView()
                        .navigationBarHidden(true)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
