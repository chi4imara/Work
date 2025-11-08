import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("hasSeenSplash") private var hasSeenSplash = false
    @State private var showingSplash = true
    
    var body: some View {
        Group {
          if !hasSeenOnboarding {
                OnboardingView {
                    hasSeenOnboarding = true
                }
            } else {
                MainContainerView()
            }
        }
        .onAppear {
            if hasSeenSplash {
                showingSplash = false
            }
        }
    }
}

#Preview {
    ContentView()
}
