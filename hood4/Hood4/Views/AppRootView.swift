import SwiftUI

struct AppRootView: View {
    @State private var isLoading = true
    @State private var isOnboardingCompleted = false
    
    var body: some View {
        ZStack {
            if !isOnboardingCompleted {
                OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
            } else {
                MainTabView()
            }
        }
        .onAppear {
            checkOnboardingStatus()
            simulateLoading()
        }
        .animation(.easeInOut(duration: 0.5), value: isLoading)
        .animation(.easeInOut(duration: 0.5), value: isOnboardingCompleted)
    }
    
    private func checkOnboardingStatus() {
        isOnboardingCompleted = UserDefaults.standard.bool(forKey: "OnboardingCompleted")
    }
    
    private func simulateLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            isLoading = false
        }
    }
}

#Preview {
    AppRootView()
}
