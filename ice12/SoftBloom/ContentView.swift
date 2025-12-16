import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: GratitudeViewModel
    
    var body: some View {
         if viewModel.showingOnboarding {
            OnboardingView(viewModel: viewModel)
        } else {
            MainTabView(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(GratitudeViewModel())
}
