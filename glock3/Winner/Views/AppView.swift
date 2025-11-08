import SwiftUI

struct AppView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        Group {
            if hasSeenOnboarding {
                MainView()
            } else {
                OnboardingView {
                    hasSeenOnboarding = true
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    AppView()
}
