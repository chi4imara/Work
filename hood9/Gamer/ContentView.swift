import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var showingSplash = true
    
    var body: some View {
        ZStack {
             if !hasSeenOnboarding {
                OnboardingView {
                    withAnimation {
                        hasSeenOnboarding = true
                    }
                }
            } else {
                MainTabView()
            }
        }
    }
}

#Preview {
    ContentView()
}
