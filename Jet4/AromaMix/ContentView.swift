import SwiftUI

struct ContentView: View {
    @EnvironmentObject var mainViewModel: MainAppViewModel
    @State private var hasStartedLoading = false
    @State private var showMainTabView = false
    
    var body: some View {
        ZStack {
      if !mainViewModel.appState.hasCompletedOnboarding {
                OnboardingView(appState: mainViewModel.appState)
                    .transition(.opacity)
            } else {
                if showMainTabView {
                    MainTabView(viewModel: mainViewModel)
                        .transition(.opacity)
                } else {
                    Color.clear
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showMainTabView = true
                                }
                            }
                        }
                }
            }
        }
        .animation(.easeInOut(duration: 0.4), value: mainViewModel.appState.isLoading)
        .animation(.easeInOut(duration: 0.4), value: mainViewModel.appState.hasCompletedOnboarding)
    }
}

#Preview {
    ContentView()
        .environmentObject(MainAppViewModel())
}
