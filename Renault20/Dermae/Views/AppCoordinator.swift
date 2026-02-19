import SwiftUI

struct AppCoordinator: View {
    @StateObject private var viewModel = SkinCareViewModel()
    @State private var showingSplash = true
    @State private var showingOnboarding = UserDefaults.standard.bool(forKey: "OnDone")
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ZStack {
            if !showingOnboarding {
                OnboardingView {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewModel.completeOnboarding()
                        showingOnboarding = true
                        UserDefaults.standard.set(true, forKey: "OnDone")
                    }
                }
            } else {
                NavigationStack {
                    MainTabView()
                        .environmentObject(viewModel)
                        .navigationBarHidden(true)
                }
            }
        }
        .onChange(of: scenePhase, perform: handleScenePhaseChange)
    }
    
    private func handleScenePhaseChange(_ newPhase: ScenePhase) {
        if newPhase == .background {
            viewModel.saveData()
        }
    }
}

#Preview {
    AppCoordinator()
}
