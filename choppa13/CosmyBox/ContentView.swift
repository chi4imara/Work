import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack {
             if appViewModel.isFirstLaunch {
                OnboardingView(appViewModel: appViewModel)
            } else {
                MainTabView(appViewModel: appViewModel)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appViewModel.showSplash)
        .animation(.easeInOut(duration: 0.5), value: appViewModel.isFirstLaunch)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppViewModel())
}
