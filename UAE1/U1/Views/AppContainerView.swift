import SwiftUI

struct AppContainerView: View {
    @StateObject private var viewModel = ProcedureViewModel()
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
           if viewModel.showOnboarding {
                OnboardingView(viewModel: viewModel)
                    .transition(.opacity)
            } else {
                MainTabView(viewModel: viewModel)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showSplash)
        .animation(.easeInOut(duration: 0.5), value: viewModel.showOnboarding)
        .onAppear {            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}

#Preview {
    AppContainerView()
}
