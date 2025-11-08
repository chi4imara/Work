import SwiftUI

struct AppContainerView: View {
    @State private var isLoading = false
    @State private var showOnboarding = true
    
    private let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    
    var body: some View {
        ZStack {
          if showOnboarding && !hasSeenOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
            } else {
                MainTabView()
            }
        }
        .onAppear {
                withAnimation {
                    isLoading = false
                    showOnboarding = !hasSeenOnboarding
                }
        }
        .onChange(of: showOnboarding) { newValue in
            if !newValue && !hasSeenOnboarding {
                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
            }
        }
    }
}

#Preview {
    AppContainerView()
}
