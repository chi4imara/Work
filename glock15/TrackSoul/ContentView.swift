import SwiftUI

struct ContentView: View {
    @State private var showingSplash = false
    @State private var showingOnboarding = true
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        ZStack {
            if !hasCompletedOnboarding {
                OnboardingView(isCompleted: $hasCompletedOnboarding)
            } else {
                MainTabView()
            }
        }
        .onChange(of: showingSplash) { newValue in
            if !newValue && !hasCompletedOnboarding {
                showingOnboarding = true
            }
        }
    }
}

#Preview {
    ContentView()
}
