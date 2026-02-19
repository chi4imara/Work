import SwiftUI

struct AppContainer: View {
    @State private var isLoading = true
    @State private var showOnboarding = false
    @State private var isOnboardingCompleted = false
    
    private let userDefaults = UserDefaults.standard
    private let onboardingKey = "OnboardingCompleted"
    
    var body: some View {
        ZStack {
            if showOnboarding {
                OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
            } else {
                MainTabView()
            }
        }
        .onAppear {
            checkOnboardingStatus()
            startLoadingTimer()
        }
        .onChange(of: isOnboardingCompleted) { completed in
            if completed {
                userDefaults.set(true, forKey: onboardingKey)
                showOnboarding = false
            }
        }
    }
    
    private func checkOnboardingStatus() {
        let hasCompletedOnboarding = userDefaults.bool(forKey: onboardingKey)
        isOnboardingCompleted = hasCompletedOnboarding
    }
    
    private func startLoadingTimer() {
        showOnboarding = !isOnboardingCompleted
    }
}

#Preview {
    AppContainer()
}
