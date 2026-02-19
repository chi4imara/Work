import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: DecisionViewModel
    @State private var isCompleted = UserDefaults.standard.bool(forKey: "isCompleted")
    
    var body: some View {
        Group {
            if !isCompleted {
                OnboardingView(isCompleted: $isCompleted)
                    .environmentObject(viewModel)
            } else {
                MainTabView()
                    .environmentObject(viewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
