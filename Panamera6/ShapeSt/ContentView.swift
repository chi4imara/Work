import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = StyleViewModel()
    
    var body: some View {
        ZStack {
            if viewModel.isShowingOnboarding {
                OnboardingView {
                    viewModel.completeOnboarding()
                }
            } else {
                NavigationStack {
                    MainTabView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
