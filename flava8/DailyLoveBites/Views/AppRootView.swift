import SwiftUI

struct AppRootView: View {
    @State private var showSplash = true
    @State private var showOnboarding = true
    @State private var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    private let dataManager = DataManager.shared
    
    var body: some View {
        ZStack {
            if !hasCompletedOnboarding {
                OnboardingView {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showOnboarding = false
                        hasCompletedOnboarding = true
                        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                    }
                }
            } else {
                MainTabView()
            }
        }
    }
}

#Preview {
    AppRootView()
}
