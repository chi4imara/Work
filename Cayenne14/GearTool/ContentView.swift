import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @State private var showOnboarding = true
    
    var body: some View {
        ZStack {
            if showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
                    .transition(.opacity)
            } else {
                MainTabView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            FontManager.shared.registerFonts()
            
            if UserDefaults.standard.bool(forKey: "HasSeenOnboarding") {
                showOnboarding = false
            }
        }
        .onChange(of: showOnboarding) { newValue in
            if !newValue {
                UserDefaults.standard.set(true, forKey: "HasSeenOnboarding")
            }
        }
    }
}

#Preview {
    ContentView()
}
