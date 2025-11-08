import SwiftUI

struct ContentView: View {
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some View {
        return ZStack {
           if !appViewModel.isOnboardingComplete {
                OnboardingView(appViewModel: appViewModel, isOnboardingComplete: $appViewModel.isOnboardingComplete)
            } else {
                MainSidebarView(appViewModel: appViewModel)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appViewModel.isLoading)
        .animation(.easeInOut(duration: 0.5), value: appViewModel.isOnboardingComplete)
    }
}

#Preview {
    ContentView()
}
