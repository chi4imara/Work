import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: FragranceViewModel
    @State private var showingSplash = true
    
    var body: some View {
        ZStack {
            if viewModel.showingOnboarding {
                OnboardingView(viewModel: viewModel)
                    .transition(.slide)
            } else {
                MainTabView(viewModel: viewModel)
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                showingSplash = false
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(FragranceViewModel())
}
