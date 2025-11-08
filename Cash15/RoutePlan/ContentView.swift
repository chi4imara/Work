import SwiftUI

struct AppRootView: View {
    @State private var showingSplash = true
    @State private var isOnboardingComplete = UserDefaults.standard.bool(forKey: "OnboardingComplete")
    
    var body: some View {
        Group {
           if !isOnboardingComplete {
                OnboardingView(isOnboardingComplete: $isOnboardingComplete)
                    .onChange(of: isOnboardingComplete) { completed in
                        if completed {
                            UserDefaults.standard.set(true, forKey: "OnboardingComplete")
                        }
                    }
            } else {
                MainTabView()
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    AppRootView()
}
