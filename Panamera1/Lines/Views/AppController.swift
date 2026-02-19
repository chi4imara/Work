import SwiftUI

struct AppController: View {
    @State private var showSplash = true
    @State private var showOnboarding = UserDefaults.standard.bool(forKey: "HasSeenOnboarding")
    
    private let hasSeenOnboarding = "HasSeenOnboarding"
    
    var body: some View {
        ZStack {
            if !showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
            } else {
                NavigationStack {
                    MainTabView()
                        .navigationBarHidden(true)
                }
            }
        }
    }
}

#Preview {
    AppController()
}
