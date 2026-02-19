import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppStateManager()
    @StateObject private var userProfile = UserProfileViewModel()
    @StateObject private var workouts = WorkoutsViewModel()
    @StateObject private var progress = ProgressViewModel()
    
    var body: some View {
        ZStack {
            if appState.showOnboarding {
                OnboardingView(showOnboarding: $appState.showOnboarding)
                    .transition(.slide)
            } else {
                CustomTabView()
                    .environmentObject(appState)
                    .environmentObject(userProfile)
                    .environmentObject(workouts)
                    .environmentObject(progress)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appState.isLoading)
        .animation(.easeInOut(duration: 0.5), value: appState.showOnboarding)
    }
}

#Preview {
    ContentView()
}
