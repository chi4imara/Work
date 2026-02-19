import SwiftUI

struct AppRootView: View {
    @StateObject private var viewModel = AppViewModel()
    @State private var showingSplash = true
    @State private var showingOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    var body: some View {
        ZStack {
            if !showingOnboarding {
                OnboardingView {
                    viewModel.completeOnboarding()
                    showingOnboarding = true
                }
            } else {
                NavigationStack {
                    MainTabView()
                        .environmentObject(viewModel)
                        .navigationBarHidden(true)
                }
            }
        }
    }
}
