import SwiftUI

struct ContentView: View {
    @State private var isShowingSplash = true
    @AppStorage("OnboardingCompleted") private var isOnboardingCompleted = false
    
    var body: some View {
        Group {
          if !isOnboardingCompleted {
                OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
            } else {
                MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.5), value: isShowingSplash)
        .animation(.easeInOut(duration: 0.5), value: isOnboardingCompleted)
    }
}

#Preview {
    ContentView()
}
