import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: BeautyDiaryViewModel
    
    var body: some View {
        Group {
           if viewModel.showingOnboarding {
                OnboardingView(viewModel: viewModel)
            } else {
                MainTabView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(BeautyDiaryViewModel())
}
