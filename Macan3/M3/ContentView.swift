import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack {
            if appViewModel.showOnboarding {
                OnboardingView(appViewModel: appViewModel)
                    .transition(.slide)
            } else {
                MainTabView(appViewModel: appViewModel)
                    .transition(.slide)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appViewModel.showSplash)
        .animation(.easeInOut(duration: 0.5), value: appViewModel.showOnboarding)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppViewModel())
}
