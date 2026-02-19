import SwiftUI

struct AppCoordinator: View {
    @StateObject private var wishViewModel = WishViewModel()
    @State private var showSplash = true
    @State private var isCompletedOnboarding: Bool = UserDefaults.standard.bool(forKey: "isCompletedOnboarding")
    
    var body: some View {
        ZStack {
            if !isCompletedOnboarding {
                OnboardingView {
                    UserDefaults.standard.set(true, forKey: "isCompletedOnboarding")
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isCompletedOnboarding = true
                    }
                }
            } else {
                MainAppView()
                    .environmentObject(wishViewModel)
            }
        }
    }
}
