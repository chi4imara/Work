import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CosmeticViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.showingOnboarding {
                OnboardingView {
                    viewModel.completeOnboarding()
                }
            } else if viewModel.isLoadingTabBar {
                ColorTheme.backgroundGradient
                    .ignoresSafeArea()
            } else {
                MainTabView(viewModel: viewModel)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
