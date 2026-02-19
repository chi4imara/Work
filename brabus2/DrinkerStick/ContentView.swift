import SwiftUI

struct ContentView: View {
    @State private var isShowingSplash = true
    @State private var isOnboardingComplete = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    var body: some View {
        ZStack {
            if !isOnboardingComplete {
                OnBoardingView(isOnboardingComplete: $isOnboardingComplete)
            } else {
                NavigationStack {
                    MainTabView()
                        .navigationBarHidden(true)
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: isShowingSplash)
        .animation(.easeInOut(duration: 0.5), value: isOnboardingComplete)
    }
}

#Preview {
    ContentView()
}
