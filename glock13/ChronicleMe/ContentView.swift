import SwiftUI

struct ContentView: View {
    @State private var showingSplash = true
    @State private var isOnboardingComplete = false
    @State private var hasLoadedState = false
    
    var body: some View {
        ZStack {
           if !isOnboardingComplete {
                OnboardingView(isOnboardingComplete: $isOnboardingComplete)
            } else {
                MainAppView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showingSplash)
        .animation(.easeInOut(duration: 0.5), value: isOnboardingComplete)
        .onAppear {
            if !hasLoadedState {
                loadOnboardingState()
                hasLoadedState = true
            }
        }
    }
    
    private func loadOnboardingState() {
        isOnboardingComplete = UserDefaults.standard.bool(forKey: "OnboardingComplete")
        print("ContentView: Loaded onboarding state - \(isOnboardingComplete)")
    }
}

#Preview {
    ContentView()
}
