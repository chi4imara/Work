import SwiftUI

struct ContentView: View {
    @StateObject private var dreamStore = DreamStore()
    @State private var showingSplash = true
    
    var body: some View {
        ZStack {
                if dreamStore.hasCompletedOnboarding {
                    MainTabView(dreamStore: dreamStore)
                } else {
                    OnboardingView(dreamStore: dreamStore)
                }
        }
        .animation(.easeInOut(duration: 0.5), value: showingSplash)
        .animation(.easeInOut(duration: 0.5), value: dreamStore.hasCompletedOnboarding)
    }
}

#Preview {
    ContentView()
}
