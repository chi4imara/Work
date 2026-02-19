import SwiftUI

struct ContentView: View {
    @State private var showOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        Group {
            if !showOnboarding {
                OnboardingView(appViewModel: appViewModel, showOnboarding: $showOnboarding)
            } else {
                NavigationStack {
                    MainTabView(appViewModel: appViewModel)
                        .navigationBarHidden(true)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppViewModel())
}
