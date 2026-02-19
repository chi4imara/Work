import SwiftUI

struct ContentView: View {
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some View {
        ZStack {
            if appViewModel.showOnboarding {
                OnboardingView {
                    appViewModel.completeOnboarding()
                }
            } else {
                MainTabView()
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
