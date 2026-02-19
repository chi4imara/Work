import SwiftUI

struct ContentView: View {
    @State private var isShowingSplash = true
    @State private var isShowingOnboarding = false
    @State private var hasSeenOnboarding = UserDefaults.standard.bool(forKey: "HasSeenOnboarding")
    
    var body: some View {
        ZStack {
            if !hasSeenOnboarding {
                OnboardingView(isShowingOnboarding: $hasSeenOnboarding)
                    .onDisappear {
                        UserDefaults.standard.set(true, forKey: "HasSeenOnboarding")
                        hasSeenOnboarding = true
                    }
            } else {
                NavigationStack {
                    MainTabView()
                        .navigationBarHidden(true)
                }
            }
        }
        .onAppear {
            if !hasSeenOnboarding {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    isShowingOnboarding = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
