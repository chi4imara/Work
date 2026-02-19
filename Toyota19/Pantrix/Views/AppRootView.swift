import SwiftUI

struct AppRootView: View {
    @StateObject private var appState = AppState()
    @State private var showingSplash = true
    @State private var showingOnboarding = UserDefaults.standard.bool(forKey: "OnboardingDone")
    
    var body: some View {
        ZStack {
            if !showingOnboarding {
                OnboardingView(isCompleted: $showingOnboarding)
            } else {
                NavigationStack {
                    MainTabView()
                        .environmentObject(appState)
                        .navigationBarHidden(true)
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showingSplash)
        .animation(.easeInOut(duration: 0.5), value: showingOnboarding)
    }
}

#Preview {
    AppRootView()
}
