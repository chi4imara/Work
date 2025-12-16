import SwiftUI

struct AppRootView: View {
    @StateObject private var memoryStore = MemoryStore()
    @State private var showingSplash = true
    
    var body: some View {
        ZStack {
          if !memoryStore.hasSeenOnboarding {
                OnboardingView(memoryStore: memoryStore)
                    .transition(.slide)
            } else {
                MainTabView()
                    .environmentObject(memoryStore)
                    .transition(.opacity)
            }
        }
        .onAppear {
            FontManager.shared.registerFonts()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showingSplash = false
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: memoryStore.hasSeenOnboarding)
    }
}

#Preview {
    AppRootView()
}
