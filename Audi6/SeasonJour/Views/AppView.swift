import SwiftUI

struct AppView: View {
    @State private var showSplash = true
    @State private var showOnboarding = true
    
    var body: some View {
        ZStack {
            if showOnboarding && !hasSeenOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
                    .onDisappear {
                        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                    }
            } else {
                NavigationStack {
                    TabBarView()
                        .navigationBarHidden(true)
                }
            }
        }
    }
    
    private var hasSeenOnboarding: Bool {
        UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    }
}

#Preview {
    AppView()
}
