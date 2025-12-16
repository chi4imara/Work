import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack {
          if appViewModel.showOnboarding {
                OnboardingView(showOnboarding: $appViewModel.showOnboarding)
                    .onDisappear {
                        appViewModel.completeOnboarding()
                    }
            } else {
                MainTabView()
                    .environmentObject(appViewModel)
            }
        }
        .onAppear {
            appViewModel.finishLoading()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppViewModel())
}
