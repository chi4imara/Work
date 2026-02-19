import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ShoppingViewModel
    
    var body: some View {
        Group {
            if !viewModel.showingOnboarding {
                OnboardingView {
                    viewModel.completeOnboarding()
                }
            } else {
                NavigationStack {
                    MainTabView(viewModel: viewModel)
                        .navigationBarHidden(true)
                        .preferredColorScheme(.dark)
                }
            }
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(ShoppingViewModel())
}
