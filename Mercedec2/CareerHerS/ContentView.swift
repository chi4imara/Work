import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            if appViewModel.showOnboarding {
                OnboardingView(appViewModel: appViewModel)
            } else {
                MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appViewModel.isLoading)
        .animation(.easeInOut(duration: 0.5), value: appViewModel.showOnboarding)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppViewModel())
}
