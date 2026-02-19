import SwiftUI

struct ContentView: View {
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some View {
        ZStack {
            if appViewModel.isFirstLaunch {
                OnboardingView(appViewModel: appViewModel)
                    .transition(.slide)
            } else {
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appViewModel.showSplash)
        .animation(.easeInOut(duration: 0.5), value: appViewModel.isFirstLaunch)
    }
}

#Preview {
    ContentView()
}
