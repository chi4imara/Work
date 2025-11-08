import SwiftUI

struct AppRootView: View {
    @State private var showOnboarding = true
    @State private var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    var body: some View {
        ZStack {
           if showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
                    .transition(.slide)
            } else {
                MainTabView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            AppTheme.registerFonts()
        }
        .onChange(of: showOnboarding) { newValue in
            if !newValue && !hasCompletedOnboarding {
                UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                hasCompletedOnboarding = true
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showOnboarding)
    }
}

#Preview {
    AppRootView()
}
