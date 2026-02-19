import SwiftUI

struct ContentView: View {
    @StateObject private var navigationViewModel = NavigationViewModel()
    
    var body: some View {
        ZStack {
            if !navigationViewModel.isOnboardingCompleted {
                OnboardingView(navigationViewModel: navigationViewModel)
            } else {
                NavigationStack {
                    MainTabView()
                        .navigationBarHidden(true)
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: navigationViewModel.showSplashScreen)
        .animation(.easeInOut(duration: 0.5), value: navigationViewModel.isOnboardingCompleted)
    }
}

#Preview {
    ContentView()
}
