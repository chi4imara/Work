import SwiftUI

struct AppContainerView: View {
    @State private var showOnboarding = true
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        ZStack {
           if showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
                    .onDisappear {
                        hasSeenOnboarding = true
                    }
            } else {
                MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showOnboarding)
    }
}

#Preview {
    AppContainerView()
}
