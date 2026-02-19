import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var showingSplash = true
    @State private var showMainContent = false
    
    var body: some View {
        ZStack {
            if showMainContent {
                MainTabView(viewModel: viewModel)
                    .transition(.opacity)
            }
        }
        .onAppear {            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showingSplash = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    showMainContent = true
                }
            }
        }
        .sheet(isPresented: $viewModel.showingOnboarding) {
            OnboardingView(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
}
