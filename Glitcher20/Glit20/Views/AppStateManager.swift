import SwiftUI
import Combine

class AppStateManager: ObservableObject {
    @Published var isLoading = true
    @Published var showOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    
    
    private let hasSeenOnboardingKey = "hasSeenOnboarding"
    
    init() {
        startSplashTimer()
    }
    
    private func checkOnboardingStatus() {
        showOnboarding = !UserDefaults.standard.bool(forKey: hasSeenOnboardingKey)
    }
    
    private func startSplashTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.isLoading = false
        }
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: hasSeenOnboardingKey)
        showOnboarding = false
    }
}

struct AppRootView: View {
    @StateObject private var appState = AppStateManager()
    
    var body: some View {
        Group {
            if !appState.showOnboarding {
                OnboardingView(showOnboarding: $appState.showOnboarding)
            } else {
                NavigationStack {
                    MainTabView()
                        .navigationBarHidden(true)
                }
            }
        }
    }
}

#Preview {
    AppRootView()
}
