import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var gadgetViewModel: GadgetViewModel
    
    var body: some View {
        Group {
            if !appViewModel.hasSeenOnboarding {
                OnboardingView(appViewModel: appViewModel)
            } else
            {
                MainTabView(gadgetViewModel: gadgetViewModel)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appViewModel.appState)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppViewModel())
        .environmentObject(GadgetViewModel())
}
