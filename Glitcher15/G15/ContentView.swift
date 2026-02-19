import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @State private var isOnboardingComplete = UserDefaults.standard.bool(forKey: "OnboardingComplete")
    
    var body: some View {
        ZStack {
            if !isOnboardingComplete {
                OnboardingView(isOnboardingComplete: $isOnboardingComplete)
                    .onDisappear {
                        UserDefaults.standard.set(true, forKey: "OnboardingComplete")
                    }
            } else {
                MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showSplash)
        .animation(.easeInOut(duration: 0.5), value: isOnboardingComplete)
    }
}

#Preview {
    ContentView()
}
