import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bagStore: BagStore
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            if bagStore.showOnboarding {
                OnboardingView(bagStore: bagStore)
                    .transition(.slide)
            } else {
                MainTabView(bagStore: bagStore)
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showSplash = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(BagStore())
}
