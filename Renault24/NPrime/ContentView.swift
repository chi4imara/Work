import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingSplash = true
    
    var body: some View {
        ZStack {
            if appState.isFirstLaunch {
                OnboardingView()
                    .environmentObject(appState)
                    .transition(.slide)
            } else {
                NavigationStack {
                    MainTabView()
                        .environmentObject(appState)
                        .transition(.opacity)
                        .navigationBarHidden(true)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showingSplash = false
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showingSplash)
        .animation(.easeInOut(duration: 0.5), value: appState.isFirstLaunch)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
