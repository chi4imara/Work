import SwiftUI

struct AppController: View {
    @State private var isLoading = true
    @State private var showOnboarding = false
    
    private let userDefaults = UserDefaults.standard
    
    var body: some View {
        ZStack {
           if showOnboarding {
                OnboardingView(isOnboardingCompleted: Binding(
                    get: { !showOnboarding },
                    set: { newValue in
                        if newValue {
                            userDefaults.set(true, forKey: Constants.UserDefaultsKeys.hasCompletedOnboarding)
                            print("Onboarding completed via binding")
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showOnboarding = false
                            }
                        }
                    }
                ))
            } else {
                MainTabView()
            }
        }
        .onAppear {
            setupApp()
        }
    }
    
    private func setupApp() {
        FontManager.shared.registerFonts()
        
        let hasCompletedOnboarding = userDefaults.bool(forKey: Constants.UserDefaultsKeys.hasCompletedOnboarding)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Animation.splash) {
            withAnimation(.easeInOut(duration: Constants.Animation.long)) {
                isLoading = false
                showOnboarding = !hasCompletedOnboarding
            }
        }
        
    }
}
