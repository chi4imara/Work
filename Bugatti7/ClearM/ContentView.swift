import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @State private var showOnboarding = true
    @State private var splashFinished = false
    
    var body: some View {
        ZStack {
            if showOnboarding && splashFinished {
                OnboardingView(showOnboarding: $showOnboarding)
                    .transition(.opacity)
            } else {
                NavigationStack {
                    MainTabView()
                        .transition(.opacity)
                        .navigationBarHidden(true)
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showSplash)
        .animation(.easeInOut(duration: 0.5), value: showOnboarding)
        .onAppear {
            if UserDefaults.standard.bool(forKey: "HasSeenOnboarding") {
                showOnboarding = false
            }
        }
        .onChange(of: showOnboarding) { newValue in
            if !newValue {
                UserDefaults.standard.set(true, forKey: "HasSeenOnboarding")
            }
        }
    }
}

#Preview {
    ContentView()
}
