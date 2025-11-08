import SwiftUI

struct AppRootView: View {
    @State private var showSplash = true
    @State private var showOnboarding = false
    @State private var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashScreen()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showSplash = false
                                if !hasCompletedOnboarding {
                                    showOnboarding = true
                                }
                            }
                        }
                    }
            } else if showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
                    .onChange(of: showOnboarding) { newValue in
                        if !newValue {
                            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                            hasCompletedOnboarding = true
                        }
                    }
            } else {
                MainTabView()
            }
        }
//        .animation(.easeInOut(duration: 0.5), value: showSplash)
//        .animation(.easeInOut(duration: 0.5), value: showOnboarding)
    }
}

#Preview {
    AppRootView()
}

