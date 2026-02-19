import SwiftUI

struct AppCoordinator: View {
    @State private var isLoading = true
    @State private var isOnboardingCompleted = UserDefaults.standard.bool(forKey: "OnboardingCompleted")
    
    var body: some View {
        ZStack {
            if !isOnboardingCompleted {
                OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
            } else {
                MainTabView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                isLoading = false
            }
        }
    }
}

#Preview {
    AppCoordinator()
}
