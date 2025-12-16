import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: OutfitViewModel
    
    var body: some View {
        ZStack {
          if viewModel.showOnboarding {
                OnboardingView(viewModel: viewModel)
            } else {
                MainTabView(viewModel: viewModel)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: viewModel.isLoading)
        .animation(.easeInOut(duration: 0.5), value: viewModel.showOnboarding)
    }
}

#Preview {
    ContentView()
        .environmentObject(OutfitViewModel())
}
